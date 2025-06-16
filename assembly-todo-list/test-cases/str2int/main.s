.section .data

.section .bss
.equ BUFFERSIZ, 4096
.lcomm user_input, BUFFERSIZ

.section .text 

.globl _start
_start:

  movl $3, %eax 
  movl $0, %ebx 
  movl $user_input, %ecx 
  movl $BUFFERSIZ, %edx 
  int $0x80 

  xorl %ecx, %ecx 
  xorl %eax, %eax 
  loop:
    movzbl user_input(%ecx), %edx 
    cmpb $'\n', %dl
    je end  
    
    subl $'0', %edx 
    imul $10, %ebx, %ebx
    addl %edx, %ebx


    incl %ecx 
    jmp loop 

  end: 
    movl $1, %eax 
    int $0x80 

