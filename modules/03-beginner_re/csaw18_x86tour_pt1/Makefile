all: function

function: function.o
	ld -m elf_i386 $^ -o $@

function.o: function.asm
	nasm -f elf $^ -o $@

clean:
	rm function.o function
