.include "stdlib.s"

.section .data

prompt: .ascii "Enter the line number of the todo you wish to delete\n\0"
.equ prompt_len, 53

.equ BUFFERSIZ, 4096

.section .bss
.lcomm user_input, BUFFERSIZ

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

  str2int: 
    movzbl user_input(%ecx), %eax
    cmpb $'\n', %al
    jmp converted 

    subl $'0', %eax
    imull $10, %edx, %edx
    addl %eax, %edx
    incl %ecx
    jmp str2int
  converted:

  # take the input and convert it to a number from a string 
# then start a loop comparing a number of \n to the input number
# every time loop we write the output of the file to the input of a new buffer 
# counting the whole time to keep count of the file size 
# 
  movl %ebp, %esp
  popl %ebp
  movl %edx, %eax
  ret
