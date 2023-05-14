global _start

section .data
  ; First let's define a string to print, but remember...now we're defining junk data in the middle of code, so we need to jump around it so there's no attempt to decode our text string
  string_to_print: db "soopdoop pwns", 0xa, 0x9, "some dope asm", 0x00  ; label: <size-of-elements> <array-of-elements>
  ; db stands for define-bytes, there's db, dw, dd, dq, dt, do, dy, and dz.  I just learned that three of those exist.  It's not really assembly-specific knowledge. It's okay.  https://www.nasm.us/doc/nasmdoc3.html
    ; The array can be in the form of a "string" or comma,separate,values,.

section .text
_start:
    push ebp      ; store ebp
    mov ebp,esp   ; store esp
    sub esp,0x40  ; get room on stack for our string

    xor ecx,ecx   ; zero ecx
    add ecx,0x20  ; set counter to 0x20
    .zerobyte:
    mov BYTE [esp+ecx-1], 0 ; zero bytes
    loop .zerobyte ; do until ecx is 0

    mov esi, string_to_print ; string func will print

; Now let's make a whole 'function' that prints a string
print_string:
  .print_char_loop:
    cmp byte [esi], 0  ; The brackets around an expression is interpreted as "the address of" whatever that expression is.. It's exactly the same as the dereference operator in C-like languages
                        ; So in this case, si is a pointer (which is a copy of the pointer from ax (line 183), which is the first "argument" to this "function", which is the pointer to the string we are trying to print)
                        ; If we are currently pointing at a null-byte, we have the end of the string... Using null-terminated strings (the zero at the end of the string definition at line 178)
    je .end
   
    mov ecx, esi  ; passing pointer to the char
    mov eax, 4    ; syscall for write
    mov ebx, 1    ; fd for stdout
    mov edx, 1    ; print just one byte

    int 0x80      ; Actually print the character
 
    inc esi        ; Increment the pointer, get to the next character
    jmp .print_char_loop

    .end:
    mov eax,1   ; exit
    mov ebx,0   ; ret val
    int 0x80
