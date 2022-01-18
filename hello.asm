section .data
    text db "Hello, World!",10,0
    text2 db "Hi,",10,0
 
section .text
    global _start
 
_start:
    mov rax,text
    call _print

    mov rax,text2
    call _print
    
    mov rax,60
    mov rdi,0
    syscall
 

;input: rax as pointer to string
;output print string at rax
_print:
    push rax
    mov rbx,0; to count the length of the string

_print_loop:
    inc rax
    inc rbx
    mov cl,[rax];rcx 8 bit equivalent
    cmp cl,0; if it is zero it means end of the String 
    jne _print_loop


    ;print the code 
    mov rax,1
    mov rdi,1
    pop rsi
    mov rdx,rbx
    syscall
    ret