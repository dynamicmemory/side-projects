.section .data 

fname: 
  .ascii "file.txt\0"

input:
  .ascii "This is a new line to add to the file\n\0"
.equ input_size, 38

newline: .ascii "\n\0"

.section .bss 
#.equ bufsiz, 500
.lcomm buffer, 4096 

.lcomm statbuf, 144 

.section .text 

.globl _start 
_start:

  #getting file size 
  movl $106, %eax 
  movl $fname, %ebx 
  movl $statbuf, %ecx
  int $0x80 

  movl statbuf+24, %esi

  #open 
  movl $5, %eax 
  movl $fname, %ebx 
  movl $02102, %ecx 
  movl $0644, %edx
  int $0x80

  movl %eax, %edi
  movl %esi, %edx
  #read
  movl $3, %eax 
  movl %edi, %ebx 
  movl $buffer, %ecx 
  #movl $bufsiz, %edx 
  int $0x80

  #write
  #movl %eax, %edx 
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
  movl $106, %eax 
  movl $fname, %ebx 
  movl $statbuf, %ecx
  int $0x80 

  movl statbuf+24, %edx

  #read
  movl $3, %eax 
  movl %edi, %ebx 
  movl $buffer, %ecx 
  #movl $bufsiz, %edx 
  int $0x80

  #write
  #movl %eax, %edx 
  movl $4, %eax
  movl $1, %ebx
  movl $buffer, %ecx 
  int $0x80
 
  movl $1, %eax 
  int $0x80
