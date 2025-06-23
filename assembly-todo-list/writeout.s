.include "stdlib.s"
.section .data

.equ fd, 12

.equ BUFFERSIZ, 4096

spacer:
  .ascii " - \0"

.section .bss

.lcomm file_buffer, BUFFERSIZ
.lcomm line_buffer, BUFFERSIZ
.lcomm space_buffer, 4

.section .text 

.globl writeout
writeout:
  pushl %ebp 
  movl %esp, %ebp 
  
write2out:
    # Read the file into our buffer 
    pushl fd(%ebp)
    pushl $file_buffer 
    pushl $BUFFERSIZ
    call read 
    addl $12, %esp 
   
#---------------------------------------------------
    # for finding seg fault in testing lets program run  normal 
    movl %eax, %edx
    movl $4, %eax 
    movl $1, %ebx
    movl $file_buffer, %ecx 
    int $syscall 
    addl $12, %esp 
    jmp end
#---------------------------------------------------
# remove whats between ---- when this feature its fixed
                             #<<<< works upto here atleast from testing, below loops
                             #     most likely contain the chaos
    # The bug is in adding the number and space to the buffer, the number needs to 
    # beconverted prior and not adding of $'0' works, gotta do it properly with a loop.
    movl %eax, %edx
    xorl %eax, %eax 
    xorl %esi, %esi 
    xorl %ecx, %ecx 
    xorl %ebx, %ebx 

    jmp addnum  

    loop:
      cmpl %ebx, %edx 
      je writeoutput
      cmpb $'\n', %al
      je addnum

      incl %ebx
      incl %ecx
      movl file_buffer(%ebx), %eax 
      movb %al, line_buffer(%ecx)

    addnum:
      xorl %edi, %edi               # set edi to zero whenever we come in here
      incl %esi
      movl %esi, line_buffer(%ecx) # This could be fucky, might need to add '0'?
      incl %ecx 
      addspace:
        cmpb $'\0', space_buffer(%edi)
        je preloop 
  
        movl space_buffer(%edi), %eax 
        movb %al, line_buffer(%ecx)
        
        incl %ecx
        incl %edi 
        jmp addspace
     preloop:
       decl %ecx
       jmp loop

    writeoutput:
      movl %ecx, %edx 
      movl $4, %eax 
      movl $1, %ebx 
      movl $line_buffer, %ecx 
      int $syscall 

  end:
  movl %ebp, %esp 
  popl %ebp 
  ret 
