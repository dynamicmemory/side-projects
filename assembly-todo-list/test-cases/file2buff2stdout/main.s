.section .data

# local vars
.equ fd, -4
.equ files_bytes, -8

fname: 
  .ascii "test.txt\0"

newline:
  .ascii "\n\0"

.section .bss 
.equ BUFFERSIZ, 4096
.lcomm buff, BUFFERSIZ
.lcomm temp, BUFFERSIZ

.section .text 

.globl _start
_start:
  # set the stack up
  pushl %ebp
  movl %esp, %ebp 
  subl $8, %esp        # by doing this im adding space for a local variables

  # open file 
  movl $5, %eax 
  movl $fname, %ebx
  movl $0x0442, %ecx
  movl $0644, %edx
  int $0x80 
  
  # int fd = %eax  
  movl %eax, fd(%ebp)

  # read input from stdin (terminal)
  movl $3, %eax 
  movl $0, %ebx 
  movl $buff, %ecx 
  movl $BUFFERSIZ, %edx 
  int $0x80
  
  # Check for / add \n to the end of the line 
  movl %eax, %esi 
  movl %eax, %edi
  decl %edi 
  cmpb $10, buff(%edi)    # comparing the last char to the ascii val for \n
  je pass

  movb $10, buff(%esi)
  incl %eax 

  pass:
    # int files_bytes = %eax 
    movl %eax, files_bytes(%ebp)     # The bytes read from the input awa size 

  # write the input to the file 
  movl $4, %eax 
  movl fd(%ebp), %ebx 
  movl $buff, %ecx 
  movl files_bytes(%ebp), %edx 
  int $0x80 
  
  # Move back to the start of the file 
  movl $19, %eax 
  movl fd(%ebp), %ebx 
  xorl %ecx, %ecx 
  xorl %edx, %edx 
  int $0x80

  # clear out the buffer 
  movl $0, %eax
  movl $buff, %edi
  movl $BUFFERSIZ, %ecx 
  shrl $2, %ecx
  rep stosl

  # read the file into the buffer 
  movl $3, %eax 
  movl fd(%ebp), %ebx
  movl $buff, %ecx 
  movl $4096, %edx 
  int $0x80
  
  # int files_bytes = %eax 
  movl %eax, files_bytes(%ebp)     # The bytes read from the file, also the size

  # Move the file pointer back to the beginning of file 
  movl $19, %eax 
  movl fd(%ebp), %ebx 
  xorl %ecx, %ecx 
  xorl %edx, %edx 
  int $0x80 

  # write the file to stdout 
  movl $4, %eax 
  movl $1, %ebx 
  movl $buff, %ecx 
  movl files_bytes(%ebp), %edx
  int $0x80
 
  # Print a newline to stdout 
  movl $4, %eax 
  movl $1, %ebx 
  movl $newline, %ecx 
  movl $2, %edx 
  int $0x80 

  movl $3, %edi
  xorl %eax, %eax
  loop:
    cmpl $0, %edi 
    je loop3

    decl %edi 
    loop2:
       
      cmpb $'\n', 
  
  loop3:



  # exit program
  movl %ebp, %esp 
  popl %ebp
  movl $1, %eax 
  int $0x80
  

# Important routines to build 
# - Read and write to and from stdin, stdout and file 
# - lseek to move the file pointer 
# - add \n to all stdin to control line manipulation
# - wiping a buffer to be used again 
# - counting the types in a file or buffer 

