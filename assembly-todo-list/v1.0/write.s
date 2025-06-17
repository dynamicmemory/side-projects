.include "syscalls.s"

.section .data

.equ fd, 16
.equ buffer, 12
.equ size, 8

.section .text 
.globl write  
write:
  pushl %ebp
  movl %esp, %ebp 

  movl $WRITE, %eax
  movl fd(%ebp), %ebx 
  movl buffer(%ebp), %ecx 
  movl size(%ebp), %edx
  int $INTERUPT
  
  movl %ebp, %esp 
  popl %ebp 
  ret 
