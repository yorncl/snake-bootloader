org 0x07C00


mov ah, 0x0 ;Set video mode, it should clean the screen too
mov al, 0x03
int 0x10

mov ah, 0x1
mov cx, 0x2607
int 0x10 ; Removing cursor

mov ax, snake_base ; Address of working-area memory for the snake
mov es, ax ; setting the extra segment

mov ax, 0xb800 ; Segment for the VGA text mode buffer
mov fs, ax


start: ; Init the game
call spawn_food
call spawn_snake

loop_start:
check_input:
	mov ah, 0x1
	int 0x16
	jz input_end
	mov ah, 0
	int 0x16 ; clearing keyboard buffer ? weird behaviour when smashing keyboard
	check_left:
	cmp al, 'a'
	jne check_up
	mov [delta], word -0x1
	jmp input_end
	check_up:
	cmp al, 'w'
	jne check_right
	mov [delta], word -0x100
	jmp input_end
	check_right:
	cmp al, 'd'
	jne check_down
	mov [delta], word 0x1
	jmp input_end
	check_down:
	cmp al, 's'
	jne input_end
	mov [delta], word 0x100

input_end:
	;clearing the snake
	mov si, ' '
	call print_snake
update_snake:
	mov ax, [snake_len]
	update_snake_loop:
	mov bx, ax
	imul bx, 2
	mov dx, word [es:bx - 2]
	mov [es:bx], word dx
	dec ax
	cmp ax, 0
	jne update_snake_loop

update_end:
	mov bx, ax
	imul bx, 2
	mov dx, [es:bx]
	add dx, [delta]
	mov [es:bx], dx ;shifting the head

	;printing the snake
	mov si, 'o'
	call print_snake

print_food:
	movzx bx, [foodx]
	movzx cx, [foody]
	mov dx, 'X'
	call put_char

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
print_snake:
	mov ax, 0
print_snake_loop:
	mov bx, ax
	imul bx, 2
	movzx cx, byte [es:bx + 1]
	movzx bx, byte [es:bx]
	mov dx, si
	call put_char
	inc ax
	cmp ax, [snake_len]
	jl print_snake_loop
	ret
put_char:
	imul cx, 80
	add cx, bx
	imul cx, 2
	mov bx, cx
	mov byte [fs:bx], dl
	ret

spawn_snake:
	mov byte [es:0], 15
	mov byte [es:1], 12
	mov byte [es:2], 14
	mov byte [es:3], 12
	mov byte [es:4], 13
	mov byte [es:5], 12
	ret

spawn_food:
	mov byte [foodx], 50
	mov byte [foody], 12
	ret

;shift_loop:
;	cmp ax, si
;	add ax, 2
;	jne shift_loop
;	ret

foodx db 1
foody db 2
delta dw 0x1
snake_base dw 0x7E1
snake_len dw 0x3

times 510-($-$$) db 0
	db 0x55
	db 0xAA
