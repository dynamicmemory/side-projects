.include "stdlib.s"
.section .data

command: .ascii "Choose an action ('a' add | 'd' delete | 'e' exit)\n\0"
.equ commandsize, 52

.section .bss 
.lcomm buffer, commandsize

.section .text 

.globl ask 
ask:
  pushl %ebp 
  movl %esp, %ebp 

  pushl $1 
  pushl $command 
  pushl $commandsize
  call write 
  addl $12, %esp

  movl %ebp, %esp 
  popl %ebp 
  ret 
 
