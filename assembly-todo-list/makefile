main: main.o open.o fsize.o read.o write.o ask.o newline.o clear.o add.o
	ld -m elf_i386 main.o open.o fsize.o read.o write.o ask.o newline.o clear.o add.o -o main 

main.o: main.s stdlib.s 
	as -32 main.s -o main.o 

open.o: open.s stdlib.s 
	as -32 open.s -o open.o 

fsize.o: fsize.s stdlib.s 
	as -32 fsize.s -o fsize.o

read.o: read.s stdlib.s 
	as -32 read.s -o read.o 

write.o: write.s stdlib.s 
	as -32 write.s -o write.o 

ask.o: ask.s stdlib.s 
	as -32 ask.s -o ask.o

newline.o: newline.s stdlib.s 
	as -32 newline.s -o newline.o

clear.o: clear.s stdlib.s 
	as -32 clear.s -o clear.o

add.o: add.s stdlib.s 
	as -32 add.s -o add.o 

clean: 
	rm main main.o open.o fsize.o read.o write.o ask.o newline.o clear.o
