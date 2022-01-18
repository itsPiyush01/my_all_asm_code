section .bss
digitSpace resb 100
digitSpacePos resb 8; is enough for 64 bit


section .text 
global _start

;123/10 =12 remainder 3
;123/10=12 R 3
;store 3
;12/10=1 R 2
;store 2
;1/10 = 0 R 1
;store 1


_start:
    mov rax,123
    call _printRAX

    mov rax,60
    mov rdi,0
    syscall



_printRAX:
    mov rcx,digitSpace
    mov rbx,10; which is newline
    mov [rcx],rbx;
    inc rcx
    mov [digitSpacePos], rcx ; measures how far we are on the string


_printRAXLoop:
    mov rdx,0; to insure it not messup our division
    mov rbx,10
    div rbx ; div the value
    push rax; store the value for now
    add rdx ,48 ; add to the remainder 3 + 48 to convert it to character
    ;rdx store the remainder 
    
    mov rcx,[digitSpacePos];
    mov [rcx],dl; lower 8 byte of the rdx that we got , mov it to our digit space 
    inc rcx
    mov [digitSpacePos],rcx

    pop rax
    cmp rax,0 ; compare it to the 0 
    jne _printRAXLoop; if it is not equal to zero then re run the loop

_printRAXLoop2:
    mov rcx,[digitSpacePos]

    mov rax,1
    mov rdi,1
    mov rsi ,rcx
    mov rdx ,1
    syscall

    mov rcx,[digitSpacePos]
    dec rcx
    mov [digitSpacePos],rcx

    cmp rcx,digitSpace
    jge _printRAXLoop2
    ret

