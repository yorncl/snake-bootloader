org 0x07C00

;clear_screen:
;	mov ah, 0x0
;	mov al, 0x7
;	int 0x10
mov ah, 0x0e
mov byte bl, [MYCHAR]
mov al, bl
int 0x10

mov ax, 0xB800
mov es, ax
mov byte [es:0xF60], 'U'

game_loop:
	jmp game_loop

MYCHAR db 'a'

times 510-($-$$) db 0
	db 0x55
	db 0xAA
