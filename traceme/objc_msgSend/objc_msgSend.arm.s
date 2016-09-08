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
//  objc_msgSend.arm.s
//  traceme
//

.globl _objc_msgSend
.globl _orig_msgSend
.zerofill __DATA,__common,_orig_msgSend,4,2
.align 2    // set 4-byte alignment

_objc_msgSend:

push   {r0-r12, lr}
bl     _trace_objc_message
pop    {r0-r12, lr}
// original objc_msgSend first using r9 register, so we can use r9 here
movw   r9, :lower16:(_orig_msgSend-(LPC1_4+8))
movt   r9, :upper16:(_orig_msgSend-(LPC1_4+8))
LPC1_4:
add    r9, pc
ldr.w  r9, [r9]
bx     r9
