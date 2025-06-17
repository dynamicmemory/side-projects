.include "syscalls.s"
.section .data


.equ fd, 16
.equ buffer, 12 
.equ BUFFERSIZ, 8

.section .text 

.globl read 
read:
  pushl %ebp
  movl %esp, %ebp 

  movl $READ, %eax 
  movl fd(%ebp), %ebx 
  movl buffer(%ebp), %ecx 
  movl BUFFERSIZ(%ebp), %edx
  int $INTERUPT

  movl %ebp, %esp 
  popl %ebp
  ret 


