format ELF64

public _start

section '.bss' writable
    place db 1
    result db 20

section '.text' executable

str_number:
    push rcx
    push rbx

    xor rax, rax
    xor rcx, rcx
.loop:
    xor rbx, rbx
    mov bl, byte [rsi + rcx]
    cmp bl, 48
    jl .finished
    cmp bl, 57
    jg .finished

    sub bl, 48
    add rax, rbx
    mov rbx, 10
    mul rbx
    inc rcx
    jmp .loop

.finished:
    cmp rcx, 0
    je .restore

    mov rbx, 10
    div rbx

.restore:
    pop rbx
    pop rcx
    ret

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

print_msg:
    ; rsi указывает на строку для печати, rdx - длина строки
    mov eax, 1               ; syscall: write
    mov edi, 1               ; file descriptor: stdout
    syscall
    ret

_start:
    pop rcx                  ; Получаем количество аргументов из стека
    cmp rcx, 4               ; Проверяем, что переданы ровно 3 аргумента
    jne .no_arg              ; Если нет, выходим

    ; Чтение первого аргумента (b)
    mov rsi, [rsp + 8]       ; Первый аргумент (b)
    call str_number          ; Конвертируем в число
    mov rbx, rax             ; Сохраняем в rbx (b)
    call print_dig           ; Печатаем b (для проверки)

    ; Чтение второго аргумента (a)
    mov rsi, [rsp + 16]      ; Второй аргумент (a)
    call str_number          ; Конвертируем в число
    mov rcx, rax             ; Сохраняем в rcx (a)
    call print_dig           ; Печатаем a (для проверки)

    ; Проверка, что a != 0
    cmp rcx, 0               ; Сравниваем a с 0
    je .div_by_zero          ; Если a = 0, выходим с ошибкой

    ; Чтение третьего аргумента (c)
    mov rsi, [rsp + 24]      ; Третий аргумент (c)
    call str_number          ; Конвертируем в число
    mov rdx, rax             ; Сохраняем в rdx (c)
    call print_dig           ; Печатаем c (для проверки)

    ; Выражение ((((b * a) / a) * b) * c)
    ; Выражение ((((b * a) / a) * b) * c)
mov rax, rbx             ; rax = b
imul rax, rcx            ; rax = b * a

xor rdx, rdx             ; Обнуляем rdx перед div
div rcx                  ; rax = (b * a) / a

imul rax, rbx            ; rax = ((b * a) / a) * b
imul rax, rdx            ; rax = (((b * a) / a) * b) * c

; Печать результата
call print_dig
         ; Печатаем окончательный результат

    ; Завершение программы
    mov eax, 60              ; syscall: exit
    xor edi, edi             ; статус: 0
    syscall

.div_by_zero:
    ; Обработка ошибки деления на ноль
    mov rsi, msg_zero_div
    mov edx, 25              ; Длина сообщения "Error: Division by zero!\n"
    call print_msg
    jmp .exit

.no_arg:
    ; Завершение программы при отсутствии аргументов
    mov eax, 60              ; syscall: exit
    xor edi, edi             ; статус: 0
    syscall

.exit:
    mov eax, 60              ; syscall: exit
    xor edi, edi             ; статус: 0
    syscall

section '.data' writable
msg_zero_div db "Error: Division by zero!", 0xA
