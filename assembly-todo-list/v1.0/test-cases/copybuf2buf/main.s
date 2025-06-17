.section .data

line:
  .ascii "Copying this line from buffer to buffer\n\0"

.equ line_len, 40

.section .bss

.lcomm bufferone, 500
.lcomm buffertwo, 500 

.section .text 

.globl _start 
_start:
  # Move the string to the buffer
  movl $line_len, %ecx 
  movl $line, %esi
  movl $bufferone, %edi
  rep movsb
  
  # Write the buffer to the out
  movl $4, %eax 
  movl $1, %ebx 
  movl $bufferone, %ecx 
  movl $line_len, %edx 
  int $0x80 

  # initialize the incrementers
  movl $0, %edx 
  movl $0, %ecx
  # Copy one byte at a time from buffone to bufftwo 
  loop:
    movzbl bufferone(%edx), %eax 
    movb %al, buffertwo(%ecx)
    cmpl $'\n', %eax
    je end

    incl %ecx 
    incl %edx
    jmp loop 

  end:
    # Print the second buffer out
    movl $4, %eax 
    movl $1, %ebx 
    movl $buffertwo, %ecx 
    movl $line_len, %edx 
    int $0x80 

    movl $1, %eax 
    int $0x80
  

