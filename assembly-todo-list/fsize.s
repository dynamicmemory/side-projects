.include "stdlib.s"
.section .data

.equ fname, 8

.section .bss 
.lcomm stats, 144 

.section .text 

.globl fsize
fsize:
  pushl %ebp 
  movl %esp, %ebp 

  movl $106, %eax 
  movl fname(%ebp), %ebx
  movl $stats, %ecx 
  int $syscall 

  movl stats+24, %eax 
  
  movl %ebp, %esp 
  popl %ebp 
  ret 
