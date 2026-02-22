BITS 32

SYS_EXIT    equ 1
SYS_WRITE   equ 4
SYS_READ    equ 3
STDIN       equ 0
STDOUT      equ 1

section .data ; constants & initialized data
    ask_msg db 'Please enter a single digit number: '
    ask_len equ $ - ask_msg

    quo_msg db 'The quotient is: '
    quo_len equ $ - quo_msg

    rem_msg db 'The remainder is: '
    rem_len equ $ - rem_msg
section .bss ; variables (reserved space)
    num1 resb 2 ; digit & newline
    num2 resb 2
    quo resb 2
    rem resb 2
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

    ; convert into nums
    sub byte [num1], '0'
    sub byte [num2], '0'

    ; zero ax (2 bytes) AH:AL (h:l) | AX: 00000000:00000000
    xor ax, ax

    ; load the first number into al | AX: 00000000:00001001 (9)
    mov al, [num1]

    ; divide the first number (in al part of ax) to the second number 
    idiv byte [num2]
    ; the results of it end up with the quotient into al and the remainder into ah

    ; al: 00001001 (9)
    ; [num2]: 00000011 (3)
    ; ax / [num2] (9/3) ->
    ; al: 00000011 (3)
    ; ah: 00000000 (0)

    ; convert the answer from a number to a string by adding 48 to it
    add al, '0'
    mov [quo], al

    add ah, '0'
    mov [rem], ah

    ; add a newline into quotient & remainder
    mov byte [quo+1], 0xa
    mov byte [rem+1], 0xa

    ; print the quotient msg
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, quo_msg
    mov edx, quo_len
    int 0x80

    ; print the quotient
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, quo
    mov edx, 2
    int 0x80

    ; print the remainder msg
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, rem_msg
    mov edx, rem_len
    int 0x80

    ; print the remainder
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, rem
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