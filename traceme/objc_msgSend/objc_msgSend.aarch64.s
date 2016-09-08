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
//  objc_msgSend.aarch64.s
//  traceme
//

.globl _objc_msgSend
.extern _orig_msgSend

_objc_msgSend:

stp  x0, x1, [sp, #-0x10]!
stp  x2, x3, [sp, #-0x10]!
stp  x4, x5, [sp, #-0x10]!
stp  x6, x7, [sp, #-0x10]!
stp  x8, x9, [sp, #-0x10]!
stp  x10, x11, [sp, #-0x10]!
stp  x12, x13, [sp, #-0x10]!
stp  x14, x15, [sp, #-0x10]!
stp  x16, x17, [sp, #-0x10]!
stp  x18, x19, [sp, #-0x10]!
stp  x20, x21, [sp, #-0x10]!
stp  x22, x23, [sp, #-0x10]!
stp  x24, x25, [sp, #-0x10]!
stp  x26, x27, [sp, #-0x10]!
stp  x28, x29, [sp, #-0x10]!
str  x30, [sp, #-0x10]!
bl   _trace_objc_message
ldr  x30, [sp], #0x10
ldp  x28, x29, [sp], #0x10
ldp  x26, x27, [sp], #0x10
ldp  x24, x25, [sp], #0x10
ldp  x22, x23, [sp], #0x10
ldp  x20, x21, [sp], #0x10
ldp  x18, x19, [sp], #0x10
ldp  x16, x17, [sp], #0x10
ldp  x14, x15, [sp], #0x10
ldp  x12, x13, [sp], #0x10
ldp  x10, x11, [sp], #0x10
ldp  x8, x9, [sp], #0x10
ldp  x6, x7, [sp], #0x10
ldp  x4, x5, [sp], #0x10
ldp  x2, x3, [sp], #0x10
ldp  x0, x1, [sp], #0x10

adrp x16, _orig_msgSend@PAGE
add  x16, x16, _orig_msgSend@PAGEOFF
ldr	 x16, [x16]
br   x16
