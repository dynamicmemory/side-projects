.include "syscalls.s"
.section .data 

clear_screen:
  .ascii "\033[2J\033[H" #\033 - esc char, [2J - entire screen, [H - cursor top left 
  .byte 0 
  
.equ clearlen, 7

.section .text 

.globl clearscreen 
clearscreen:
  
  movl $WRITE, %eax
  movl $STDOUT, %ebx
  movl $clear_screen, %ecx 
  movl $clearlen, %edx 
  int $INTERUPT 
  ret 

