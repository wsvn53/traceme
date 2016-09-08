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
//  objc_msgSend.i386.s
//  traceme
//

.globl _objc_msgSend

_objc_msgSend:

push  %eax
push  %ebx
push  %ecx
push  %edx
push  %edi
push  %esi
push  %ss
push  %ds
push  %es
push  %fs
push  %gs
#   per push is 8 bytes, i386 require 16 bytes align, so align 8 bytes
subl  $8, %esp
#   i386 arguments read from stack memory, only need first 2 args here
push  60(%esp)
push  60(%esp)
call  _trace_objc_message
pop   %eax
pop   %eax
#   restore 16 bytes align
addl  $8, %esp
pop   %gs
pop   %fs
pop   %es
pop   %ds
pop   %ss
pop   %esi
pop   %edi
pop   %edx
pop   %ecx
pop   %ebx
pop   %eax
jmp   *_orig_msgSend
