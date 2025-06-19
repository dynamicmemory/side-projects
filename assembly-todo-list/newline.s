.include "stdlib.s"
.section .data

new: .ascii "\n\0"

.section .text 
.globl newline
newline:
  movl $4, %eax
  movl $1, %ebx
  movl $new, %ecx
  movl $2, %edx
  int $syscall

  ret
