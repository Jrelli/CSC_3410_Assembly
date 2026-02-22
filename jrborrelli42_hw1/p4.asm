BITS 32

SYS_EXIT    equ 1
SYS_WRITE   equ 4
SYS_READ    equ 3
STDIN       equ 0
STDOUT      equ 1

section .data ; constants & initialized data
    ask_msg db 'Please enter a two character string: '
    ask_len equ $ - ask_msg

    ans_msg db 'The answer is: '
    ans_len equ $ - ans_msg
section .bss ; variables (reserved space)
    inout resb 3 ; two chars & nl
section .text ; actual code
    global _start 

_start:
    ; inout: 00000000 00000000 00000000

    ; prompt the user for a 2 char string
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, ask_msg
    mov edx, ask_len
    int 0x80

    ; read the 2 char string from the keyboard
    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, inout
    mov edx, 3
    int 0x80

    ; inout: 01101000 01101001 00001010 (hi\n)
    
    ; put chars into regs
    mov al, inout[0]
    mov bl, inout[1] 

    ; al: 01101000 (h)
    ; bl: 01101001 (i)

    ; reconstruct chars into the new output
    mov inout[0], bl
    mov inout[1], al
    ; inout: 01101001 01101000 00001010 (ih\n)

    ; print the answer msg
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, ans_msg
    mov edx, ans_len
    int 0x80

    ; print the output
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, inout
    mov edx, 3
    int 0x80

    ; exit
    mov eax, SYS_EXIT
    xor ebx, ebx
    int 0x80

; commands to use: ADD MOV SUB IMUL IDIV
; how to compile:
    ; nasm -g -f elf -F dwarf -o p1.o p1.asm
    ; ld p1.o -m elf_i386 -o p1