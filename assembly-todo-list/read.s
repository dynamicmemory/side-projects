.include "stdlib.s"
.section .data 

.equ fd, 16
.equ buffer, 12 
.equ size, 8 

.section .text 

.globl read 
read:
  pushl %ebp
  movl %esp, %ebp 

  movl $3, %eax 
  movl fd(%ebp), %ebx
  movl buffer(%ebp), %ecx 
  movl size(%ebp), %edx 
  int $syscall

  movl %ebp, %esp
  popl %ebp 
  ret 
