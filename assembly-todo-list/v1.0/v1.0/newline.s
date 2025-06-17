.include "syscalls.s"
.section .data 
new:
  .ascii "\n\0"

.section .text
.globl newline
newline:
  movl $WRITE, %eax 
  movl $STDOUT, %ebx
  movl $new, %ecx
  movl $2, %edx
  int $INTERUPT
  ret 
