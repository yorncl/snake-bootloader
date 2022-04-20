org 0x07C00


mov ah, 0x0 ;Set video mode, it should clean the screen too
mov al, 0x03
int 0x10

mov ah, 0x1
mov cx, 0x2607
int 0x10 ; Removing cursor

mov ax, 0xB800 ; Address of VGA text buffer
mov es, ax ; setting the extra segment

mov ax, snake_base ; Address of working-area memory for the snake
mov ds, ax


start: ; Init the game
call spawn_food
call spawn_snake

loop_start:
check_input:
	mov ah, 0x1
	int 0x16
	jz update_snake
	mov ah, 0
	int 0x16 ; clearing keyboard buffer ? weird behaviour when smashing keyboard
	mov [direction], al

update_snake:
	;mov al, [snake_base + 1]
	;mov al, [snake_base + 1]

print_snake:
	mov ax, 0
print_snake_loop:
	mov bx, ax
	imul bx, 2
	movzx cx, byte [ds:bx + 1]
	movzx bx, byte [ds:bx]
	mov dx, 'o'
	add dx, ax
	call put_char
	inc ax
	mov bx, [snake_len]
	cmp ax, bx
	jl print_snake_loop

print_food:
	movzx bx, byte [food]
	movzx cx, byte [food + 1]
	mov dx, 'X'
	;call put_char

wait_a_bit:
	mov ah, 0x86
	mov dx, 0xFFFF
	mov cx, 0x0
	int 0x15
loop:
	jmp loop_start

;
; Callable procedures
;
put_char:
	imul cx, 80
	add cx, bx
	imul cx, 2
	mov bx, cx
	mov byte [es:bx], dl
	ret

spawn_snake:
	mov byte [ds:0], 39
	mov byte [ds:1], 12
	mov byte [ds:2], 38
	mov byte [ds:3], 12
	ret

spawn_food:
	mov byte [food], 40
	mov byte [food + 1], 12
	ret

;shift_snake:
;	mov si, [len]
;	imul si, 2
;	mov ax, 0
;shift_loop:
;	cmp ax, si
;	add ax, 2
;	jne shift_loop
;	ret

food dw 0x7E0
snake_base dw 0x7E1
direction db 'd'
snake_len dw 2

times 510-($-$$) db 0
	db 0x55
	db 0xAA
