.include "stdlib.s"

.section .data

fname: .ascii "database.txt\0"

.section .bss 
.equ BUFFERSIZ, 4096
.lcomm file_buffer, BUFFERSIZ
.lcomm input_buffer, BUFFERSIZ
.lcomm command_buffer, BUFFERSIZ

.section .text 
.equ fd, -4
.equ file_size, -8 

.globl _start
_start:
  # set up the stack 
  pushl %ebp
  movl %esp, %ebp 
  subl $8, %esp

  # open the file
  pushl $fname 
  pushl $0x422 
  pushl $0644 
  call open 
  addl $12, %esp

  # int fd = eax 
  movl %eax, fd(%ebp)

  pushl $fname 
  call fsize 
  addl $4, %esp 

  movl %eax, file_size(%ebp)

  # read file in 
  pushl fd(%ebp)
  pushl $file_buffer
  pushl $BUFFERSIZ
  #pushl file_size(%ebp)
  call read 

  #movl %eax, file_size(%ebp)
  # Write the file to stdout 
  movl $4, %eax 
  movl $1, %ebx
  movl $file_buffer, %ecx 
  movl file_size(%ebp), %edx
  int $syscall

  # Ask user what they want to do 
  # call ask_user

  # cmpb $'a', %al
  # push what is needed 
  # call add
  # reset values 
  # jmp start 

  # cmpb $'d', %al 
  # push what is needed 
  # call delete 
  # reset values 
  # jmp start 

  # cmpb $'e', %al 
  # jmp end 

  # end 
  movl $1, %eax     # change 1 to exit 
  int $0x80        
