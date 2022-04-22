org 0x07C00



mov ax, 0x07E1 ; Address of working-area memory for the snake
mov es, ax ; setting the extra segment

mov ax, 0xb800 ; Segment for the VGA text mode buffer
mov fs, ax


start: ; Init the game
mov ax, 0x03 ; go vga text mode
int 0x10

mov ah, 0x1
mov cx, 0x2607
int 0x10 ; Removing cursor

; Setting the default values
mov [delta], word 0x1
mov [snake_len], word 0x4

call spawn_food
call spawn_snake

check_input:
	mov ah, 0x1
	int 0x16
	jz input_end
	mov ah, 0
	int 0x16 ; clearing keyboard buffer ? weird behaviour when smashing keyboard
	check_left:
	cmp al, 'a'
	jne check_up
	mov si, word -0x1
	jmp check_backward
	check_up:
	cmp al, 'w'
	jne check_right
	mov si, word -0x100
	jmp check_backward
	check_right:
	cmp al, 'd'
	jne check_down
	mov si, word 0x1
	jmp check_backward
	check_down:
	cmp al, 's'
	jne input_end
	mov si, word 0x100
check_backward:
	mov di, si
	imul di, -1
	cmp di, [delta]
	je input_end
	mov [delta], si
input_end:
	;clearing the snake
	mov si, ' '
	call print_snake
handle_growth:
	cmp [growth], byte 0
	je update_snake
	inc word [snake_len]
	dec byte [growth]
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
check_out_of_bounds:
	cmp [es:0], byte 0
	jl start
	cmp [es:0], byte 79
	jg start
	cmp [es:1], byte 0
	jl start
	cmp [es:1], byte 24
	jg start
check_collisions:
	mov ax, 1
	mov dx, word [es:0]
	check_collisions_loop:
	mov bx, ax
	imul bx, 2
	cmp dx, word [es:bx]
	je start
	inc ax
	cmp ax, [snake_len]
	jne check_collisions_loop

check_collision_food:
	mov si, word [food]
	mov di, word [es:0]
	cmp di , si
	jne print_food
	add [growth], byte 4
	call spawn_food

print_food:
	mov dx, [food]
	movzx bx, dl
	movzx cx, dh
	mov dx, 'X'
	call put_char

wait_a_bit:
	mov ah, 0x86
	mov dx, 0xFFFF
	mov cx, 0x0
	int 0x15

; Go back to start
jmp check_input

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
	mov word [es:0], 0x0b0f
	mov word [es:2], 0x0b0e
	mov word [es:4], 0x0b0d
	mov word [es:6], 0x0b0c
	ret

spawn_food:
	mov bx, word 80
	call random
	mov [food + 1 ], byte 12
	mov bx, word 25
	call random
	mov [food], byte 25
	ret
random:
	push ax

	xor ax, ax
	int 0x1a
	mov ax, cx
	xor dx, dx
	div bx
	mov si, dx

	pop ax
	ret

food dw 0
delta dw 0x1
snake_len dw 0x4
growth db 0

times 510-($-$$) db 0
	db 0x55
	db 0xAA
