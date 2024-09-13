format ELF
public _start
msg db "Lisitsin", 0xA, "Artem", 0xA, "Dmitrievich", 0xA, 0

_start:
    ; Инициализация регистров для вывода информации на экран
    mov eax, 4        
    mov ebx, 1        
    mov ecx, msg      
    mov edx, 28       
    int 0x80          

    ; Инициализация регистров для успешного завершения работы программы
    mov eax, 1        
    mov ebx, 0        
    int 0x80