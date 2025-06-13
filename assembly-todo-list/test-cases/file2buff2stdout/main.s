.section .data

# local vars
.equ fd, -4
.equ file_size, -8

fname: 
  .ascii "test.txt\0"

.section .bss 
.lcomm buff, 4096

.section .text 

.globl _start
_start:
  # set the stack up
  pushl %ebp
  movl %esp, %ebp 
  subl $8, %esp        # by doing this im adding space for a local var named fd 

  # open file 
  movl $5, %eax 
  movl $fname, %ebx
  movl $00, %ecx
  movl $0644, %edx
  int $0x80 
  
  # fd = %eax  
  movl %eax, fd(%ebp)

  # read the file into the buffer 
  movl $3, %eax 
  movl fd(%ebp), %ebx
  movl $buff, %ecx 
  movl $4096, %edx 
  int $0x80
  
  # file_size = %eax 
  movl %eax, file_size(%ebp)

  # write the file to stdout 
  movl $4, %eax 
  movl $1, %ebx 
  movl $buff, %ecx 
  movl file_size(%ebp), %edx
  int $0x80

  # exit program
  movl %ebp, %esp 
  popl %ebp
  movl $1, %eax 
  int $0x80
  
