.section .data 

fname: 
  .ascii "file.txt\0"

input:
  .ascii "This is a new line to add to the file\n\0"
.equ input_size, 38

newline: .ascii "\n\0"

.section .bss 
.equ bufsiz, 500
.lcomm buffer, bufsiz 

.section .text 

.globl _start 
_start:
  #open 
  movl $5, %eax 
  movl $fname, %ebx 
  movl $02102, %ecx 
  movl $0644, %edx
  int $0x80

  movl %eax, %edi
  #read
  movl $3, %eax 
  movl %edi, %ebx 
  movl $buffer, %ecx 
  movl $bufsiz, %edx 
  int $0x80

  #write
  movl %eax, %edx 
  movl $4, %eax
  movl $1, %ebx
  movl $buffer, %ecx 
  int $0x80

  #append
  movl $4, %eax 
  movl %edi, %ebx 
  movl $input, %ecx 
  movl $input_size, %edx 
  int $0x80

  #lseek
  movl $19, %eax 
  movl %edi, %ebx
  movl $0, %ecx 
  movl $0, %edx 
  int $0x80

  #newline
  movl $4, %eax 
  movl $1, %ebx 
  movl $newline, %ecx 
  movl $2, %edx 
  int $0x80

  #countfilesize 


  #read
  movl $3, %eax 
  movl %edi, %ebx 
  movl $buffer, %ecx 
  movl $bufsiz, %edx 
  int $0x80

  #write
  movl %eax, %edx 
  movl $4, %eax
  movl $1, %ebx
  movl $buffer, %ecx 
  int $0x80
 
  movl $1, %eax 
  int $0x80
