.include "stdlib.s"

.section .data

.equ fname, 16
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
    xorl %edi, %edi

  str2int_start: 
    movzbl user_input(%ecx), %eax
    cmpb $'\n', %al
    je str2int_end 

    subl $'0', %eax
    imull $10, %edi, %edi
    addl %eax, %edi
    incl %ecx
    jmp str2int_start
  str2int_end:
  
  # Read the file into the buffer  
  pushl fd(%ebp)
  pushl $file_buffer
  pushl $BUFFERSIZ
  call read 
  addl $12, %esp 
  
  # Set all regs ready for deleteing line 
  movl %eax, %esi
  movl %edi, %edx
  xorl %ecx, %ecx 
  xorl %ebx, %ebx
  # Loops to the right line
  loop:
    xorl %eax, %eax
    
    cmpl $1, %edx 
    je loop3

    decl %edx 
    # Loops till new line char 
    loop2:
      cmpb $'\n', %al
      je loop

      movl file_buffer(%ecx), %eax
      movb %al, newfile_buffer(%ebx)

      incl %ecx 
      incl %ebx
      
      jmp loop2
  # Iterates through line we want to delete not copying it to new buffer 
  loop3:
    cmpb $'\n', %al 
    je loop4

    movl file_buffer(%ecx), %eax 
    incl %ecx
    jmp loop3
  # Finished reading the rest of the file into new buffer
  loop4:
    cmpl %esi, %ecx
    je finish

    movl file_buffer(%ecx), %eax
    movb %al, newfile_buffer(%ebx)
    incl %ecx
    incl %ebx
    
    jmp loop4
  finish:
    # move the new file size into the size param 
    movl %ebx, size(%ebp)

    # Close old file  
    movl $6, %eax
    movl fd(%ebp), %ebx 
    int $syscall

    # Open new version of file in trunc mode 
    movl $5, %eax
    movl fname(%ebp), %ebx
    movl $0x202, %ecx
    movl $0644, %edx 
    int $syscall
    
    # move the new fd into the fd param
    movl %eax, fd(%ebp)
    
    # Write the new buffer to the file 
    pushl fd(%ebp)
    pushl $newfile_buffer
    pushl size(%ebp)
    call write 
    addl $12, %esp
    
    # close the file again
    movl $6, %eax 
    movl fname(%ebp), %ebx
    int $syscall

    # Open the file again in rdwr mode 
    movl $5, %eax
    movl fname(%ebp), %ebx 
    movl $0x442, %ecx
    movl $0644, %edx
    int $syscall 

  movl %ebp, %esp
  popl %ebp
  ret
