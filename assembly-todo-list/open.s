.include "stdlib.s"
.section .data 

.equ fname, 16
.equ flag, 12 
.equ permissions, 8
.section .text 

# .type open, @function # it's easier to just declare this as global instead of func
.globl open
open:
  pushl %ebp
  movl %esp, %ebp 

  movl $5, %eax
  movl fname(%ebp), %ebx 
  movl flag(%ebp), %ecx 
  movl permissions(%ebp), %edx
  int $syscall
  
  movl %ebp, %esp 
  popl %ebp 
  ret 
