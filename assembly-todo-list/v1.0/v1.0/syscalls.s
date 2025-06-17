# File system calls 
.equ OPEN, 5
.equ CLOSE, 6
.equ READ, 3
.equ WRITE, 4
.equ EXIT, 1
.equ INTERUPT, 0x80

# I/O system calls 
.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2 

# File modes  
.equ O_RDONLY, 0x000
.equ O_WRONLY, 0x001
.equ O_RDWR, 0x002
.equ O_CREATE, 0x040
.equ O_TRUNC, 0x200 
.equ O_APPEND, 0x400


