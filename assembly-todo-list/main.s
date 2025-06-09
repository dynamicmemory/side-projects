.include "syscalls.s"
.section .data

fname:
  .ascii "database.txt\0"

command:
  .ascii "What would you like to do? ('a' - add|'d'- delete)\0"

.equ cmd_len, 51 

add_msg:
  .ascii "What would you like to add?\0"


.section .bss
.equ BUFFERSIZ, 500
.lcomm buffer, BUFFERSIZ

.section .text 
.globl _start
_start:
  # Init stack and base pointer 
  pushl %ebp 
  movl %esp, %ebp
  
  # Open the file 
  pushl $fname 
  pushl $0x402  
  pushl $0644
  call open 
  addl $12, %esp 
  
  # eax now has our fd, push it onto the stack 
  pushl %eax 
  loop:
  # Read the file into the buffer 
  pushl $buffer 
  pushl $BUFFERSIZ
  call read 
  addl $8, %esp # Only add 12, keep the fd on the stack 
  
  # Write the buffer to stdout, eax has file size in bytes returned from read 
  pushl $STDOUT 
  pushl $buffer
  pushl %eax 
  call write 
  addl $12, %esp 

  # ask user for command 
  pushl $STDOUT 
  pushl $command 
  pushl $cmd_len
  call write 
  addl $12, %esp 

  call newline
  
  # Read users input 
  pushl $STDIN
  pushl $buffer
  pushl $BUFFERSIZ
  call read 
  addl $12, %esp
 
  movzbl buffer, %eax

  cmpl $'a', %eax
  je add 

  cmpl $'d', %eax
  je delete  

  cmpl $'e', %eax 
  je exit 

  jmp loop 

  add:
    pushl $STDOUT 
    pushl $add_msg
    pushl $28
    call write 
    addl $12, %esp

    call newline

    pushl $STDIN 
    pushl $buffer
    pushl $BUFFERSIZ
    call read 
    addl $12, %esp 
 
    pushl $buffer 
    pushl $BUFFERSIZ
    call write 
    addl $8, %esp

    jmp loop

  delete:
    jmp end 

  exit:
    jmp end 

  end: 
    movl %ebp, %esp
    popl %ebp 

    movl $1, %eax
    int $INTERUPT


