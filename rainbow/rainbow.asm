bits 16
org 0x7c00

; clear segment registers
xor ax, ax
mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax

start:
	; 40x25. 256 colors. 320x200 pixels. 1 page.
	mov ah, 0x00
	mov al, 0x13
	int 0x10

	; set video memory
	mov ax, 0xA000
	mov es, ax

flush:
	xor di, di
	mov al, byte [baseIndex]

	mov cx, 25
.fill_block:
	push cx
	mov cx, 8
.fill_rows:
	push cx
	mov cx, 320
.fill_cols:
	mov [es:di], al
	inc di

	loop .fill_cols
	pop cx

	loop .fill_rows
	pop cx

	inc al
	cmp al, 0x37
	jle .skip_reset_color
	mov al, 0x20
.skip_reset_color:
	loop .fill_block

	mov ah, 0x86
	mov cx, 0x00
	mov dx, 0xC350
	int 0x15

	inc byte [baseIndex]
	cmp byte [baseIndex], 0x37
	jle flush
	mov byte [baseIndex], 0x20
	jmp flush

baseIndex: db 0x20

; boot sector signature
times 510 - ($ - $$) db 0
dw 0xAA55
