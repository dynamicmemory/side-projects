.include "stdlib.s"
.section .data

command: .ascii "Choose an action ('a' add | 'd' delete | 'e' exit)\n\0"
.equ commandsize, 52
.equ BUFFERSIZ, 5

.section .bss 
.lcomm buffer, commandsize
.lcomm input_buffer, BUFFERSIZ

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

  pushl $0
  pushl $input_buffer
  pushl $BUFFERSIZ
  call read 
  #addl $12, %esp

  movzbl input_buffer, %eax

  movl %ebp, %esp 
  popl %ebp 
  ret 
 
