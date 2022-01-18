section .data
    welcomeText db "################ Welcome to ASM_Calculator ################",10,0
    command_text db 10,"Choose an operator : +, -, *, or /",10,0
    invalid db "Invalid operator ",10,"Give inputs again",10,0
    exit_text db "For exit Enter 'X' or ctrl + c ",10,0
    text1 db "Enter 1st number :",0
    text2 db "Enter 2st number :",0
    equal_char db " = ",0
    operator_input db "0",0
section .bss
    n1 resb 64;
    n2 resb 64;
    n3 resb 64;
    result resb 64;
    num1 resb 64; 16 byte reserve name variable
    num2 resb 64; 16 byte reserve name variable
    digitSpace resb 100
    digitSpacePos resb 8; is enough for 64 bit
    
section .text
global _start


%macro exit 0
    mov rax,60
    mov rdi ,0
    syscall
%endmacro

%macro displayString 1
    mov rax,0
    mov rax,%1
    call _print
%endmacro

%macro displayInteger 1
    mov rax,0
    mov rax,[%1]
    call _printRAXInt

%endmacro


%macro takeInput 1
    mov rsi,%1
    call _getInput
%endmacro

%macro strToInt 2 
    mov rdx,%1
    call _stringToInteger
    mov [%2] ,rax
%endmacro


_addition:    
    mov rax,operator_input
    mov rbx,'+ '
    mov [operator_input],rbx
    mov rax,[num1]
    add rax, [num2]
    mov [result],rax
    ret

_subtraction:
    mov rbx,'- '
    mov [operator_input],rbx
    mov rax,[num1]
    sub rax,[num2]
    mov [result],rax
    ret

_multiplication:
    mov rbx,'* '
    mov [operator_input],rbx
    mov rax,[num1]
    mov rbx,[num2]
    mul rbx
    mov [result],rax
    ret

_division:
    mov rbx,'/ '
    mov [operator_input],rbx
    mov rdx,0
    mov rax,[num1]
    mov rbx,[num2]
    div rbx
    mov [result],rax
    ret

_exit:
    mov rax,60
    mov rdi ,0
    syscall



_welcome:
    displayString welcomeText
    ret 

_menu:
    displayString command_text
    displayString exit_text
    takeInput operator_input
    mov rax,operator_input
    mov cl,[rax]

    ; if user enter X or X
    cmp cl ,'X'
    je _exit
    ; je hello
    cmp cl ,'x'
    je _exit; both are working macros and label here why ? 

    displayString text1 
    takeInput n1
    displayString text2
    takeInput n2
    

    strToInt n1,num1
    strToInt n2,num2

    mov rax,operator_input
    mov cl,[rax]
    cmp cl,'+'
    je _addition

    cmp cl,'-'
    je _subtraction 

    cmp cl,'*'
    je _multiplication 

    cmp cl,'/'
    je _division 


    displayString invalid
    call _menu

   ret

_print_result:
    ; num1 + num2 = result
    displayInteger num1
    displayString operator_input
    displayInteger num2
    displayString equal_char
    displayInteger result
    ret
    
_main:
    call _menu
    call _print_result
    call _main

_start:	
    call _welcome
    call _main
    exit


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

    
; For taking number from user 
_getInput:
    mov rax ,0 ;id 0 means sys_in
    mov rdi , 0; 0=>standard_input , 1=>standard_output , 2=>standard_error 
    ; mov rsi ,num; where we're going to save the data
    mov rdx ,16
    syscall
    ret

_printRAXInt:
    mov rcx,digitSpace
    mov rbx ,32;which is space 
    ; mov rbx,10; which is newline
    mov [rcx],rbx;
    inc rcx
    mov [digitSpacePos], rcx ; measures how far we are on the string


_printRAXLoop:
    mov rdx,0; to insure it not mess up  our division
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




_stringToInteger:
    ; mov rdx, num ; our string
    atoi:
    xor rax, rax ; zero a "result so far"
    .top:
    movzx rcx, byte [rdx] ; get a character
    inc rdx ; ready for next one
    cmp rcx, '0' ; valid?
    jb .done
    cmp rcx, '9'
    ja .done
    sub rcx, '0' ; "convert" character to number
    imul rax, 10 ; multiply "result so far" by ten
    add rax, rcx ; add in current digit
    jmp .top ; until done
    .done:
    ret 