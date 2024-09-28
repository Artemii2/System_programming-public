format ELF64

public _start

section '.bss' writable
  place db 1

section '.text' executable
print_dig:
    xor rbx, rbx     

    cmp rax, 9
    jle .single_digit       

    mov rcx, 10              
.loop:
    xor rdx, rdx            
    div rcx                
    push rdx                 
    inc rbx                  
    test rax, rax            
    jnz .loop                

.print_loop:
    pop rax                 
    add rax, '0'            
    mov [place], al         

    mov eax, 1               
    mov edi, 1             
    mov rsi, place       
    mov edx, 1             
    syscall

    dec rbx                
    jnz .print_loop         

    ret

.single_digit:
    add rax, '0'           
    mov [place], al         

    mov eax, 1         
    mov edi, 1              
    mov rsi, place          
    mov edx, 1               
    syscall
    ret

_start:
    pop rcx
    cmp rcx, 2
    jl .no_arg             

    mov rsi, [rsp + 8]     
    movzx rax, byte [rsi]  
    call print_dig          
    mov eax, 60             
    xor edi, edi           
    syscall

.no_arg:
    mov eax, 60           
    xor edi, edi            
    syscall