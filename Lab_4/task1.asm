format ELF64
public _start

msg rb 255

include 'func.asm'

_start:
 mov rsi, msg
 call input_keyboard
    call str_number
 mov rcx, rax
 mov rax, 1
 xor rbx, rbx
 .loop:
  inc rax
  cmp rax, rcx
  je .end
  call division
  cmp rdi, 0
  jne .loop
  inc rbx
  jmp .loop
 .end:
  mov rax, rbx
  call number_str
  call print_str
  call print_new


  call exit