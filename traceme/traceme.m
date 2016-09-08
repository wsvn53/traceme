//
//  Copyright (C) Ethan.
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
//  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//
//  traceme.m
//  traceme
//

#import "traceme.h"
#import <stdio.h>
#import <dlfcn.h>
#import <objc/runtime.h>

#define buffer_length   1024000
#define print_buffer_interval   0.5f
#define rules_max_size   102400

// objc class buffer
static Class objc_classes[buffer_length];

// objc selector name buffer, index sync with objc_classes
static SEL   objc_selectors[buffer_length];

// mark method with +/- sign, index sync with objc_classes
// - true: class method
// - false: instance method
static bool  objc_classmeth_signs[buffer_length];

static long string_index = 0;

void trace_objc_init();

void trace_objc_message (void *self, SEL op)
{
    if (orig_msgSend == 0) {
        trace_objc_init();
        return;
    }
    
    string_index ++;
    long string_index_copy = string_index;
    if (string_index_copy > buffer_length) {
        return;
    }
    
    Class objectClass = object_getClass((__bridge id)self);
    objc_classes[string_index_copy-1] = objectClass;
    objc_selectors[string_index_copy-1] = op;
    objc_classmeth_signs[string_index_copy-1] = class_isMetaClass(objectClass);
}

__attribute__((constructor))
void trace_objc_init ()
{
    if (orig_msgSend != NULL) {
        return;
    }
    
    printf("Trace objc_msgSend initialize.\n");
    void *dl_handle = dlopen("/System/Library/Frameworks/Foundation.framework/Foundation", RTLD_NOW);
    orig_msgSend = dlsym(dl_handle, "objc_msgSend");
}

static const char *trace_ignore_pairs[rules_max_size] = {
    "traceme", "NS", "_"
};

static const char *trace_allow_pairs[rules_max_size] = { };
static Class trace_class_pairs[rules_max_size] = { };

@implementation traceme

+(void)load
{
    @autoreleasepool {
        [(id)self performSelector:@selector(printObjc) withObject:nil afterDelay:print_buffer_interval];
    }
}

+(void)ignore:(NSString *)className
{
    const char *class_name = [className UTF8String];
    int rule_count = rules_max_size;
    for (int rule_index = 0; rule_index < rule_count; rule_index++) {
        if (trace_ignore_pairs[rule_index] == NULL) {
            trace_ignore_pairs[rule_index] = class_name;
            return;
        }
    }
}

+(void)trace:(NSString *)className
{
    const char *class_name = [className UTF8String];
    int rule_count = rules_max_size;
    for (int rule_index = 0; rule_index < rule_count; rule_index++) {
        if (trace_allow_pairs[rule_index] == NULL) {
            trace_allow_pairs[rule_index] = class_name;
            
            // cache Class object
            Class traceClass = objc_getMetaClass(class_name)?:[self class];
            trace_class_pairs[rule_index] = traceClass;
            return;
        }
    }
}

+(void)reset
{
    memset(trace_ignore_pairs+3, 0, rules_max_size-1);  // remain first 3 ignore rules
    memset(trace_allow_pairs, 0, rules_max_size);
}

+(BOOL)classMatchIgnoreRules:(const char *)class_name orClass:(Class)class
{
    if (class_name == NULL || strcmp(class_name, "nil") == 0) {
        return YES;
    }
    
    return [self classMatch:class_name orClass:class withRules:trace_ignore_pairs withClasses:nil];
}

+(BOOL)classMatchAllowRules:(const char *)class_name orClass:(Class)class
{
    if (class_name == NULL || strcmp(class_name, "nil") == 0) {
        return NO;
    }
    
    return [self classMatch:class_name orClass:class withRules:trace_allow_pairs withClasses:trace_class_pairs];
}

+(BOOL)classMatch:(const char *)class_name orClass:(Class)object_class withRules:(const char **)rules withClasses:(Class *)classes
{
    int rule_count = rules_max_size;
    for (int rule_index = 0; rule_index < rule_count; rule_index++) {
        const char *rule_name = rules[rule_index];
        
        if (rule_name == NULL) {
            break;
        }
        
        if (strncmp(class_name, rule_name, strlen(rule_name)) == 0) {
            return YES;
        }
        
        if (classes != nil && classes[rule_index] != [self class] &&
            [object_class isSubclassOfClass:classes[rule_index]]) {
            return YES;
        }
    }
    
    return NO;
}

+(void)printObjc
{
    static dispatch_queue_t printer_queue = NULL;
    if (printer_queue == NULL) {
        printer_queue = dispatch_queue_create("OBJC_QUEUE", DISPATCH_QUEUE_SERIAL);
    }
    dispatch_async(printer_queue, ^{
        long string_count = string_index, enumetate_counter = 0;
        while (enumetate_counter < string_count) {
            Class objectClass = objc_classes[enumetate_counter];
            if (objectClass == NULL) {
                goto next;
            }
            
            const char *class_name = class_getName(objectClass);
            Class metaClass = objc_getMetaClass(class_name);
            const char *selector_name = sel_getName(objc_selectors[enumetate_counter]);
            
#define print_symbol printf("OBJC: %s[%s %s]\n", objc_classmeth_signs[enumetate_counter]?"+":"-", class_name, selector_name)
            if (trace_allow_pairs[0] != NULL) {
                // only trace allowed pairs
                if ([self classMatchAllowRules:class_name orClass:metaClass] &&
                    [self classMatchIgnoreRules:class_name orClass:metaClass] == NO) {
                    print_symbol;
                }
            } else if ([self classMatchIgnoreRules:class_name orClass:metaClass] == NO) {
                // and then match ignore rules
                print_symbol;
            }
            
        next:
            enumetate_counter ++;
        }
        string_index = 0;
    });
    [(id)self performSelector:@selector(printObjc) withObject:nil afterDelay:print_buffer_interval];
}

@end
