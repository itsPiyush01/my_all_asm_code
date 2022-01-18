section .data
    text1 db "what is your name? "; 
    text2 db "Hello, "

section .bss
; to reserve data
    name resb 16; 16 byte reserve name variable

section .text
    global _start

_start:
    
    ;sub routines
    call _printText1
    call _getName
    call _printText2
    call _printName

    mov rax,60;id 60 --> means sys_exit
    mov rdi ,0;arg1 0 --> no error handle 
    syscall ; call to the kernel 



_getName:
    mov rax ,0 ;id 0 means sys_in
    mov rdi , 0; 0=>standard_input , 1=>standard_output , 2=>standard_error 
    mov rsi ,name; where we're going to save the data
    mov rdx ,16
    syscall
    ret

_printText1:
    mov rax,1;id=1 means sys_write
    mov rdi,1;arg1 #filescriptor
    mov rsi,text1;arg2  $buffer
    mov rdx ,19;arg3 #count
    syscall
    ret


_printText2:
    mov rax,1
    mov rdi,1
    mov rsi,text2
    mov rdx ,7; length of String
    syscall
    ret


_printName:
    mov rax,1
    mov rdi,1
    mov rsi,name
    mov rdx ,16; max length 16 
    syscall
    ret