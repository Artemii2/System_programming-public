format ELF64 

public _start 

public calcuate_numbers 
 
include 'func.asm' 
 
section '.data' 
symbol db '-' 
 
section '.bss' writable 
    place rb 255 
    answer rb 2 
     
section '.text' executable 
_start: 
    mov rsi, place 
    call input_keyboard 
    call str_number 
    call calcuate_numbers 
    mov rax, rdi 
    mov rsi, answer 
    call number_str 
    call print_str 
    call new_line 
    call exit 
