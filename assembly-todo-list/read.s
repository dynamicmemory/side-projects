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

  movl %eax, %esi   # store eax momentarily 

  # Rewind the fd back to the start of the file to read again later
  movl $19, %eax
  movl $0, %ecx
  movl $0, %edx 
  int $syscall 

  movl %esi, %eax 

  movl %ebp, %esp
  popl %ebp 
  ret 
