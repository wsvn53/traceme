# Traceme

A library for tracing Objective-C methods called.

# Trace rule

Default trace rule:
```objc
trace: ["traceme", "NS", "_"]
```

Ignore trace class:
```objc
// ignore trace class UIViewController or classes inherited from UIViewController 
[traceme ignore:@"UIViewController"];  
// ignore trace classes with "NS" prefix.
[traceme ignore:@"NS"];
```

Trace whitelist:
```objc
// trace class UIViewController or classes inherited from UIViewController
[traceme trace:@"UIViewController"];
// trace class with prefix "MM"
[traceme trace:@"MM"];
```

Reset trace list to default:
```objc
[traceme reset];
```
