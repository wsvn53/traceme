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
//  objc_msgSend-x86_64.s
//  traceme
//

.globl _objc_msgSend

_objc_msgSend:

push  %rax
push  %rbx
push  %rcx
push  %rdx
push  %rdi
push  %rsi
push  %r8
push  %r9
push  %r10
push  %r11
push  %r12
push  %r13
push  %r14
callq _trace_objc_message
pop  %r14
pop  %r13
pop  %r12
pop  %r11
pop  %r10
pop  %r9
pop  %r8
pop  %rsi
pop  %rdi
pop  %rdx
pop  %rcx
pop  %rbx
pop  %rax
jmp  *_orig_msgSend(%rip)
