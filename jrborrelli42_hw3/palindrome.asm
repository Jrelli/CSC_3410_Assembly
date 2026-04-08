section .data
    prompt      db "Please enter a string:", 10
    prompt_len  equ $ - prompt
    is_pal_msg  db "It is a palindrome", 10
    is_pal_len  equ $ - is_pal_msg
    not_pal_msg db "It is NOT a palindrome", 10
    not_pal_len equ $ - not_pal_msg

section .bss
    buffer      resb 1024

section .text
    global _start

_start:

main_loop:
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, prompt_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 1024
    int 0x80

    ; If the first byte is a newline (ASCII 10), exit (no input)
    cmp byte [buffer], 10
    je exit_program

    ; decrement length (in EAX) to get rid of newline
    dec eax             ; count-- (ignore the newline)
    
    ; is_palindrome(buffer, count)
    push eax            ; Push len
    push buffer         ; Push buffer pointer
    call is_palindrome
    add esp, 8          ; Clean up stack (2 arguments * 4 bytes)

    ; Check result (EAX will be 1 or 0)
    cmp eax, 1
    je print_is_palindrome

print_not_palindrome:
    mov eax, 4
    mov ebx, 1
    mov ecx, not_pal_msg
    mov edx, not_pal_len
    int 0x80
    jmp main_loop

print_is_palindrome:
    mov eax, 4
    mov ebx, 1
    mov ecx, is_pal_msg
    mov edx, is_pal_len
    int 0x80
    jmp main_loop

exit_program:
    mov eax, 1          ; sys_exit
    xor ebx, ebx        ; return 0
    int 0x80

is_palindrome:
    push ebp
    mov ebp, esp
    push esi
    push edi

    mov esi, [ebp + 8]  ; buffer pointer
    mov ecx, [ebp + 12] ; len
    
    test ecx, ecx
    jle return_true

    mov edi, esi
    add edi, ecx
    dec edi

compare_loop:
    cmp esi, edi
    jge return_true

    mov al, [esi]
    mov bl, [edi]
    cmp al, bl
    jne return_false

    inc esi
    dec edi
    jmp compare_loop

return_false:
    mov eax, 0
    jmp finish_func

return_true:
    mov eax, 1

finish_func:
    pop edi
    pop esi
    mov esp, ebp
    pop ebp
    ret