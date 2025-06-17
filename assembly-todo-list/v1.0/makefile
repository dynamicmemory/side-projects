main: main.o write.o open.o read.o newline.o clearscreen.o
	ld -m elf_i386 main.o write.o open.o newline.o read.o clearscreen.o -o main 

main.o: main.s syscalls.s 
	as -32 main.s syscalls.s -o main.o 

open.o: open.s syscalls.s 
	as -32 open.s syscalls.s -o open.o 

write.o: write.s syscalls.s 
	as -32 write.s syscalls.s -o write.o 

read.o: read.s syscalls.s 
	as -32 read.s syscalls.s -o read.o 

newline.o: newline.s syscalls.s
	as -32 newline.s syscalls.s -o newline.o

clearscreen.o: clearscreen.s syscalls.s 
	as -32 clearscreen.s syscalls.s -o clearscreen.o

clean:
	rm main.o write.o read.o open.o main 
