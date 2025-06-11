.include "syscalls.s"
.section .data

fname:
  .ascii "database.txt\0"

command:
  .ascii "What would you like to do? ('a' - add|'d'- delete)\0"

.equ cmd_len, 51 

add_msg:
  .ascii "What would you like to add?\0"

delete_msg:
  .ascii "Enter the number of the todo to remove\0"

.section .bss
.equ BUFFERSIZ, 4096
.lcomm buffer, 4096
.lcomm statbuff, 144    # a buffer containing file information

.section .text 
.globl _start
_start:
  # Init stack and base pointer 
  pushl %ebp 
  movl %esp, %ebp

  call clearscreen 

  # Open the file 
  pushl $fname 
  pushl $0x402  
  pushl $0644
  call open 
  addl $12, %esp 
  
  # eax now has our fd, push it onto the stack 
  pushl %eax 
  loop:

    #count the file size 
    movl $106, %eax
    movl $fname, %ebx 
    movl $statbuff, %ecx
    int $0x80

    # file size is at 24 offset from start of addr 
    movl statbuff+24, %esi  

    # Read the file into the buffer 
    pushl $buffer 
    pushl %esi
    call read 
    addl $8, %esp # Only add 12, keep the fd on the stack 
    
    # Write the buffer to stdout, eax has file size in bytes returned from read 
    pushl $STDOUT 
    pushl $buffer
    pushl %eax 
    call write 
    addl $12, %esp 

    call newline

    # ask user for command 
    pushl $STDOUT 
    pushl $command 
    pushl $cmd_len
    call write 
    addl $12, %esp 

    call newline
    
    # Read users input 
    pushl $STDIN
    pushl $buffer
    pushl $BUFFERSIZ
    call read 
    addl $12, %esp
 
    movzbl buffer, %eax

    cmpl $'a', %eax
    je add 

    cmpl $'d', %eax
    je delete  

    cmpl $'e', %eax 
    je exit 

    #wind back the pointer - abstract eventually
    movl $19, %eax 
    popl %ebx 
    movl $0, %ecx 
    movl $0, %edx
    int $0x80
    # repush the fd back onto the stack
    pushl %ebx

    call clearscreen

    jmp loop 

  add:
    # ask add command
    pushl $STDOUT 
    pushl $add_msg
    pushl $28
    call write 
    addl $12, %esp

    call newline

    #buffer reset
    movl $0, %eax 
    movl $buffer, %edi
    movl $BUFFERSIZ, %ecx
    shrl $2, %ecx #shifts bits to the right, taking away a power of 2
    rep stosl
    
    # Read user input 
    pushl $STDIN 
    pushl $buffer
    pushl $BUFFERSIZ
    call read 
    addl $12, %esp 

    #add \n to end of input/confirm line ends with \n 
    decl %eax 
    movb buffer(,%eax,1), %bl 
    cmpb $0x0A, %bl 
    jne no_newline 

    movb $0x0A, buffer(,%eax,1)
    incl %eax 
    #movb $0x00, buffer(,%eax,1)
    #incl %eax

    jmp done

    no_newline:
      incl %eax 
      movb $0x0A, buffer(,%eax,1)
      incl %eax 
      #movb $0x00, buffer(,%eax,1)

    done:
    
    # write to file 
    pushl $buffer 
    pushl %eax
    call write 
    addl $8, %esp

    #wind back the pointer - abstract eventually
    movl $19, %eax 
    popl %ebx 
    movl $0, %ecx 
    movl $0, %edx
    int $0x80
    # repush the fd back onto the stack
    pushl %ebx
    
    call clearscreen

    jmp loop

  delete:
    # write message to user  
    pushl $STDOUT
    pushl $delete_msg 
    pushl $39
    call write 
    addl $12, %esp 

    call newline
 
    # clean my shialebuff
    movl $0, %eax 
    movl $buffer, %edi 
    movl $BUFFERSIZ, %ecx
    shrl $2, %ecx
    rep stosl 

    # Get requested deleted number 
    pushl $STDIN
    pushl $buffer 
    pushl $BUFFERSIZ 
    call read 
    addl $12, %esp

    movzbl buffer, %edi 
    # reading the file, not cleaning buffer as we should rewrite, though should.
    pushl $buffer 
    pushl %esi 
    call read 
    addl $8, %esp 

    #now we need to count new lines 
    movl $0, %ecx
    movl $0, %edx
    find_line:
      movl $0, %eax

      cmpl $0, %edi 
      je found_line

      decl %edi 
      find_line_inner:
        cmpl $'\n', %eax 
        je find_line

        incl %ecx 
        movl buffer(,%ecx,4), %eax
        jmp find_line_inner

    found_line:
      movl buffer(,%ecx,4), %eax  # Now we shouild be at the first char of the line we want 
      movl (%eax), temp_buffer(,%edx, 4)
      incl %edx
      incl %ecx 

      cmpl $'\n', %eax 
      je finished 

      jmp found_line

    # essentially if this works here, then all we have to do is read up too the 
    # newline in find_line_inner and write that all into a buffer, then we go to 
    # found line and move to the next newline, then we write everything after that 
    # to the end of the file to a second buffer, then we open the file in trunc mode 
    # write in the first buffer, close file, reopen in rdrw mode, and append the second 
    # buffer, bim bam boom, deleted a line.... so eazy... 
    finished: 
      # temporarily as a test I want to print the output of the line we got first 
      movl $106, %eax 
      movl $temp_buffer, %edi 
      movl 
      pushl $temp_buffer
      pushl $temp_buffer_size 
    jmp loop
  exit:
    jmp end 

  end: 
    movl %ebp, %esp
    popl %ebp 

    movl $1, %eax
    int $INTERUPT


