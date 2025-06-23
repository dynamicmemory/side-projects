.include "stdlib.s"
.section .data

.equ fd, 16
.equ file, 12 
.equ size, 8

.equ BUFFERSIZ, 4096

spacer:
  .ascii " - \0"

.section .bss

.lcomm file_buffer, BUFFERSIZ
.lcomm line_buffer, BUFFERSIZ

.section .text 

.globl write
write:
  pushl %ebp 
  movl %esp, %ebp 
  
  write2file:
    movl $4, %eax 
    movl fd(%ebp), %ebx
    movl file(%ebp), %ecx 
    movl size(%ebp), %edx 
    int $syscall 
    jmp end

  end:
  movl %ebp, %esp 
  popl %ebp 
  ret 
