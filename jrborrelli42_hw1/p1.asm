BITS 32

SYS_EXIT    equ 1
SYS_WRITE   equ 4
SYS_READ    equ 3
STDIN       equ 0
STDOUT      equ 1

section .data ; constants & initialized data
    ask_msg db 'Please enter a single digit number: '
    ask_len equ $ - ask_msg

    ans_msg db 'The answer is: '
    ans_len equ $ - ans_msg
section .bss ; variables (reserved space)
    num1 resb 2 ; digit & newline
    num2 resb 2
    result resb 2
section .text ; actual code
    global _start 

_start:
    ; prompt the user for a single digit number
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, ask_msg
    mov edx, ask_len
    int 0x80

    ; read the number from the keyboard
    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, num1
    mov edx, 2
    int 0x80

    ; prompt the user for the second single digit number
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, ask_msg
    mov edx, ask_len
    int 0x80

    ; read the second number from the keyboard
    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, num2
    mov edx, 2
    int 0x80

    ; convert the first number represented as a string to a number by subtracting 48 from it (if the first number is in al, then all you have to do is: sub al, '0')
    mov al, [num1]
    sub al, 48

    ; convert the second number represented as a string to a number by subtracting 48 from it
    mov bl, [num2]
    sub bl, 48

    ; add the first number to the second number and save the answer
    add al, bl

    ; convert the answer from a number to a string by adding 48 to it
    add al, 48
    mov [result], al

    ; add a newline into result
    mov byte [result+1], 0xa

    ; print "The answer is: "
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, ans_msg
    mov edx, ans_len
    int 0x80

    ; print the saved answer
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, result
    mov edx, 2
    int 0x80

    ; exit
    mov eax, SYS_EXIT
    xor ebx, ebx
    int 0x80


; commands to use: ADD MOV SUB IMUL IDIV
; how to compile:
    ; nasm -g -f elf -F dwarf -o p1.o p1.asm
    ; ld p1.o -m elf_i386 -o p1
