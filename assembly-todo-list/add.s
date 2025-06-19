.include "stdlib.s"
.section .data 

.equ fd, 8

prompt: 
  .ascii "What do you need to do?\n\0"
.equ prompt_size, 25

.section .bss
.equ BUFFERSIZ, 4096
.lcomm todo, BUFFERSIZ

.section .text 

.globl add 
add:
  pushl %ebp 
  movl %esp, %ebp 
  
  # Prompt the user to add to the list 
  pushl $1 
  pushl $prompt 
  pushl $prompt_size
  call write
  addl $12, %esp 

  # Read in the users input 
  pushl $0
  pushl $todo 
  pushl $BUFFERSIZ
  call read 
  addl $12, %esp 

  # Write it to the database
  pushl fd(%ebp)
  pushl $todo 
  pushl %eax 
  call write 
  addl $12, %esp 

  # TODO abstract this and the one in read away into a separate func
  # wind the file back to the beginning again
  movl $19, %eax 
  movl fd(%ebp), %ebx
  movl $0, %ecx 
  movl $0, %edx 
  int $syscall

  movl %ebp, %esp 
  popl %ebp
  ret
