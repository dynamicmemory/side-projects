# TODO Add title with instructions 
# TODO Abstract away cleaning buffers 
# TODO Rewrite "x - " using a buffer in writeout 
# Comb through all files to check for things ive long forgotten

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
  pushl $0x442 
  pushl $0644 
  call open 
  addl $12, %esp

  # int fd = eax 
  movl %eax, fd(%ebp)
  
  loop:

  # clear the screen
  call clear

  # Get the file size 
  pushl $fname
  call fsize 
  addl $4, %esp 
  
  # move the filesize into its variable 
  movl %eax, file_size(%ebp)

  # read file in 
  pushl fd(%ebp)
  pushl $file_buffer
  pushl file_size(%ebp)
  call read 
  addl $12, %esp

  # Write the file to stdout  (using old write)
  #pushl $1
  #pushl $file_buffer
  #pushl file_size(%ebp)
  #call write
  #addl $12, %esp 
  
  # TODO - adds numbers to todos, uncomment this block and remove above write 
  #        block when fully implemented in write_out.s
  pushl fd(%ebp)
  pushl file_size(%ebp)
  call writeout
  addl $8, %esp

  call newline
  
  # Ask user to choose a command  
  call ask 

  # Branches for decisions
  cmpb $'a', %al 
  je add_item 

  cmpb $'d', %al 
  je del 

  cmpb $'e', %al 
  je exit

  jmp loop

  add_item:
    # TODO force add \n to the end of every input
    # Call add 
    pushl fd(%ebp)
    call add      
    addl $4, %esp 
    
    jmp loop

  del:
    pushl $fname
    pushl fd(%ebp)
    pushl file_size(%ebp)
    call delete
    addl $12, %esp
    
    movl %eax, fd(%ebp)

    # ABSTRACT TOMRROW - clear buffer 
    movl $0, %eax
    movl $file_buffer, %edi
    movl $BUFFERSIZ, %ecx
    shrl $2, %ecx
    rep stosl

    jmp loop
  exit:
    jmp end 

  end: 
    movl $1, %eax     # change 1 to exit 
    int $0x80        
