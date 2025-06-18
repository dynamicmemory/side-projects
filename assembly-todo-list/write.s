.include "stdlib.s"
.section .data

.equ fd, 16
.equ file, 12 
.equ size, 8

.section .text 

.globl write
write:
  pushl %ebp 
  movl %esp, %ebp 

  movl $4, %eax 
  movl fd(%ebp), %ebx
  movl file(%ebp), %ecx 
  movl size(%ebp), %edx 
  int $syscall 

  movl %ebp, %esp 
  popl %ebp 
  ret 
