.include "stdlib.s"

.section .data

.equ fd, 12
.equ size, 8

prompt: .ascii "Enter the line number of the todo you wish to delete\n\0"
.equ prompt_len, 53

.equ BUFFERSIZ, 4096

.section .bss
.lcomm user_input, BUFFERSIZ
.lcomm file_buffer, BUFFERSIZ
.lcomm newfile_buffer, BUFFERSIZ

.section .text 

.globl delete
delete:
  pushl %ebp 
  movl %esp, %ebp 

  # Prompt the user to which todo to delete
  pushl $1
  pushl $prompt 
  pushl $prompt_len
  call write
  addl $12, %esp

  # read the file into a buffer 
  pushl $0
  pushl $user_input
  pushl $BUFFERSIZ
  call read 
  addl $12, %esp

  # convert input to int 
    xorl %ecx, %ecx 
    xorl %edx, %edx

  str2int_start: 
    movzbl user_input(%ecx), %eax
    cmpb $'\n', %al
    je str2int_end 

    subl $'0', %eax
    imull $10, %edx, %edx
    addl %eax, %edx
    incl %ecx
    jmp str2int_start
  str2int_end:
  
  # Read the file into the buffer  
  pushl fd(%ebp)
  pushl $file_buffer
  pushl $BUFFERSIZ
  call read 
  addl $12, %esp 
  
  movl %eax, %esi
  xorl %ecx, %ecx 
  xorl %ebx, %ebx
  loop:
    xorl %eax, %eax

    cmpl $1, %edx 
    je loop3

    decl %edx 
    loop2:
      cmpb $'\n', %al
      je loop

      movl file_buffer(%ecx), %eax
      movb %al, newfile_buffer(%ebx)

      incl %ecx 
      incl %ebx
      
      jmp loop2
  loop3:
    cmpb $'\n', %al 
    je loop4

    movl file_buffer(%ecx), %eax 
    incl %ecx

  loop4:
    cmpl size(%ebp), %ecx
    je finish

    movl file_buffer(%ecx), %eax
    movb %al, newfile_buffer(%ebx)
    incl %ecx
    incl %ebx
    
    jmp loop4

    
  finish:

  pushl $1
  pushl $newfile_buffer
  # temp size for testing
  pushl $10            
  call write
  addl $12, %esp 

  movl %ebp, %esp
  popl %ebp
  ret
