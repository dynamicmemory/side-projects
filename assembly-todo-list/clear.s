.include "stdlib.s"
.section .data

clear_screen:
  .ascii "\033[2J\033[H" #\033 - esc char, [2J - entire screen, [H - cursor top left 
  .byte 0 
  
.equ len, 7

.section .text

.globl clear 
clear:
  pushl %ebp
  movl %esp, %ebp 

  pushl $1
  pushl $clear_screen
  pushl $len
  call write
  addl $12, %esp 

  movl %ebp, %esp
  popl %ebp
  ret 
