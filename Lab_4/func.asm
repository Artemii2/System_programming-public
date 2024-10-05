section '.data' writable
    div_msg db 'Division by zero', 0xA, 0

section '.text' executable

; Ввод данных с клавиатуры
input_keyboard:
    mov rax, 0          ; Системный вызов для чтения
    mov rdi, 0          ; Стандартный ввод
    mov rdx, 255        ; Размер буфера для ввода
    syscall             ; Выполнение системного вызова
    ret

; Преобразование строки в число
; Вход rsi - указатель на строку
; Выход rax - число
str_number:
    xor rax, rax        ; Обнуляем результат
    xor rcx, rcx        ; Счетчик символов
    xor rbx, rbx        ; Временный регистр для чисел
.parse_loop:
    mov bl, byte [rsi+rcx]   ; Читаем символ
    cmp bl, 0x30        ; Сравниваем с '0'
    jb .done            ; Если меньше, конец строки
    cmp bl, 0x39        ; Сравниваем с '9'
    ja .done            ; Если больше, конец строки
    sub bl, 0x30        ; Преобразуем символ в число
    imul rax, rax, 10   ; Умножаем текущее число на 10
    add rax, rbx        ; Прибавляем следующую цифру
    inc rcx             ; Переходим к следующему символу
    jmp .parse_loop     ; Цикл
.done:
    ret

; Функция деления
; Вход: rax - делимое, rbx - делитель
; Выход: rdi - результат деления
division:
    cmp rbx, 0          ; Проверяем делитель на ноль
    je .div_zero        ; Если ноль, выводим сообщение об ошибке
    xor rdx, rdx        ; Обнуляем регистр остатка
    div rbx             ; Деление rax на rbx
    mov rdi, rax        ; Сохраняем результат в rdi
    ret
.div_zero:
    mov rsi, div_msg    ; Адрес сообщения
    call print_str      ; Выводим сообщение
    call exit           ; Завершаем программу

; Преобразование числа в строку
; Вход: rax - число, выход: rsi - строка
number_str:
    mov rsi, msg        ; Адрес буфера для строки
    xor rbx, rbx        ; Счетчик цифр
    mov rcx, 10         ; Десятичная система счисления
.convert_loop:
    xor rdx, rdx        ; Обнуляем rdx
    div rcx             ; Делим rax на 10
    add dl, '0'         ; Преобразуем цифру в символ
    mov [rsi + rbx], dl ; Записываем символ в строку
    inc rbx             ; Увеличиваем счетчик
    test rax, rax       ; Проверяем, осталось ли еще число
    jnz .convert_loop   ; Если да, продолжаем
    mov byte [rsi + rbx], 0   ; Завершаем строку нулевым байтом
    ret

; Вывод строки
; Вход: rsi - указатель на строку
print_str:
    mov rax, 1          ; Системный вызов для записи
    mov rdi, 1          ; Стандартный вывод
    mov rdx, 255        ; Максимальный размер данных
    syscall             ; Выполнение системного вызова
    ret

; Печать новой строки
print_new:
    mov rsi, 0xA        ; Символ новой строки
    mov rdx, 1          ; Один байт
    call print_str      ; Вызов функции печати
    ret

; Завершение программы
exit:
    mov rax, 60         ; Системный вызов для завершения программы
    xor rdi, rdi        ; Код завершения
    syscall             ; Выполнение системного вызова
    ret

section '.data' writable
    div_msg db 'Division by zero', 0xA, 0

section '.text' executable

; Проверка делимости на число, переданное в rdi
; Вход: rax - число, rdi - делитель
; Выход: rax - 1, если делится, 0 - если не делится
is_divisible:
    push rdx
    xor rdx, rdx        ; Обнуляем rdx перед делением
    div rdi             ; Делим rax на rdi
    test rdx, rdx       ; Проверяем остаток от деления
    sete al             ; Если остаток нулевой, значит делится
    pop rdx
    ret

; Функция деления
; Вход: rax - делимое, rbx - делитель
; Выход: rdi - результат деления
division:
    cmp rbx, 0          ; Проверяем делитель на ноль
    je .div_zero        ; Если ноль, выводим сообщение об ошибке
    xor rdx, rdx        ; Обнуляем регистр остатка
    div rbx             ; Деление rax на rbx
    mov rdi, rax        ; Сохраняем результат в rdi
    ret
.div_zero:
    mov rsi, div_msg    ; Адрес сообщения
    call print_str      ; Выводим сообщение
    call exit           ; Завершаем программу

; Остальные функции: input_keyboard, str_number, number_str, print_str, print_new, exit - остаются теми же.
