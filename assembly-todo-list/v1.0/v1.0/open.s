
# Fn for opening file or creating if one doesn't exist
# Fn for reading from cli and from file
# Fn for writing to stdout and file 
# Main routine to get user command and execute correct line of logic
.include "syscalls.s"
.section .data

.equ fname, 16
.equ mode, 12
.equ priv, 8

.section .text 

.globl open 
open:
   pushl %ebp
   movl %esp, %ebp 
 
   movl $OPEN, %eax
   movl fname(%ebp), %ebx
   movl mode(%ebp), %ecx
   movl priv(%ebp), %edx
   int $INTERUPT

   movl %ebp, %esp
   popl %ebp 
   ret 

