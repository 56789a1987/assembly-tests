bits 16
org 0x7c00

; clear segment registers
xor ax, ax
mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax
mov ss, ax

start:
	; 40x25. 256 colors. 320x200 pixels. 1 page.
	mov ah, 0x00
	mov al, 0x13
	int 0x10
	mov di, 0

	; read sectors from drive
	mov ch, 0 ; cylinder
	mov cl, 1 ; sector
	mov dh, 0 ; head
	mov dl, 0 ; A:
.read_sect:
	mov ax, 0
	mov es, ax
	mov bx, buffer ; 0x7c00 + 512
	mov ah, 0x02 ; int13h function 2
	mov al, 36 ; read 36 sectors
	int 0x13

	; if something went wrong
	jc .end

	; set video memory
	mov ax, 0xA000
	mov es, ax

	mov si, buffer
	mov bx, 0

	; skip the first 512 bytes of the first cylinder (MBR)
	or ch, ch
	jnz .draw_pixel
	add si, 0x200
	add bx, 0x200
.draw_pixel:
	; put data into video memory
	lodsb
	stosb

	; if the whole screen has been filled
	cmp di, 320 * 200
	je .end

	; loop filling loaded pixels
	inc bx
	cmp bx, 0x200 * 36
	jl .draw_pixel

	; next cylinder
	inc ch
	jmp .read_sect
.end:
	hlt
	jmp .end

; boot sector signature
times 510 - ($ - $$) db 0
dw 0xAA55

; image data
buffer:
incbin 'image.bin'
