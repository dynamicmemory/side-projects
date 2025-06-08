.include "syscalls.s"
.section .data

fname:
  .ascii "database.txt\0"

command:
  .ascii "What would you like to do? ('a' - add|'d'- delete)\0"

msg:
  .ascii "it worked\0"

a:
  .ascii "a\0"

.equ cmd_len, 51 

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

  # Read users input 
  pushl $STDIN
  pushl $buffer
  pushl $1 
  call read 
  addl $12, %esp
 
  
  movl buffer, %eax  # buffer holds users input 
  movl %eax, %ebx    # moving to b for debugging 
  #jmp end 
  #movl %eax, %al    # might need to use bytes instead of words 
  cmpl $a, %eax      # this is broken af
  je add 
  jmp end 

  add:
    pushl $STDOUT 
    pushl $msg 
    pushl $10
    call write 
    addl $12, %esp
    jmp end
  # delete, add, exit 
  # return matching action
  # Repeat
  #jmp end 
  end: 
    movl %ebp, %esp
    popl %ebp 

    movl $1, %eax
    int $INTERUPT


