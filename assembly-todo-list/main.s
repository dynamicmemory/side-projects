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
.equ BUFFERSIZ, 4096
.lcomm buffer, 4096
.lcomm statbuff, 144    # a buffer containing file information

.section .text 
.globl _start
_start:
  # Init stack and base pointer 
  pushl %ebp 
  movl %esp, %ebp

  call clearscreen 

  # Open the file 
  pushl $fname 
  pushl $0x402  
  pushl $0644
  call open 
  addl $12, %esp 
  
  # eax now has our fd, push it onto the stack 
  pushl %eax 
  loop:

    #count the file size 
    movl $106, %eax
    movl $fname, %ebx 
    movl $statbuff, %ecx
    int $0x80

    # file size is at 24 offset from start of addr 
    movl statbuff+24, %esi  

    # Read the file into the buffer 
    pushl $buffer 
    pushl %esi
    call read 
    addl $8, %esp # Only add 12, keep the fd on the stack 
    
    # Write the buffer to stdout, eax has file size in bytes returned from read 
    pushl $STDOUT 
    pushl $buffer
    pushl %eax 
    call write 
    addl $12, %esp 

    call newline

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

    #wind back the pointer - abstract eventually
    movl $19, %eax 
    popl %ebx 
    movl $0, %ecx 
    movl $0, %edx
    int $0x80
    pushl %ebx

    call clearscreen

    jmp loop 

  add:
    # ask add command
    pushl $STDOUT 
    pushl $add_msg
    pushl $28
    call write 
    addl $12, %esp

    call newline

    #buffer reset
    movl $0, %eax 
    movl $buffer, %edi
    movl $BUFFERSIZ, %ecx
    shrl $2, %ecx #shifts bits to the right, taking away a power of 2
    rep stosl
    
    # Read user input 
    pushl $STDIN 
    pushl $buffer
    pushl $BUFFERSIZ
    call read 
    addl $12, %esp 
    
    # write to file 
    pushl $buffer 
    pushl %eax
    call write 
    addl $8, %esp

    #wind back the pointer - abstract eventually
    movl $19, %eax 
    popl %ebx 
    movl $0, %ecx 
    movl $0, %edx
    int $0x80

    pushl %ebx
    
    call clearscreen

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


