bits 16
org 0x7c00

; clear segment registers
xor ax, ax
mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax

mov esp, 0x7c00
mov ebp, esp

start:
	; read additional data from disk
	mov ah, 0x02 ; function 02
	mov al, 8 ; sectors to read (8 * 512 = 4,096)
	mov ch, 0 ; cylinder
	mov cl, 2 ; from sector
	mov dh, 0 ; head
	mov bx, buffer
	int 0x13

	; setup PC speaker
	mov al, 182
	out 0x43, al

play_song:
	call clear_screen

	mov word [text_index], text_maps
	mov cx, 1610 ; notes count
	mov si, song

song_loop:
	lodsw

	; if it's zero, stop the sound, or update frequency
	or ax, ax
	jz .stop_beep

	; start beep
	out 0x42, al
	mov al, ah
	out 0x42, al

	in al, 0x61
	or al, 0x03
	out 0x61, al
	jmp .skip_stop_beep

.stop_beep:
	; stop beep
	in al, 0x61
	and al, 0xfc
	out 0x61, al

.skip_stop_beep:
	call print_text

	; delay
	push cx
	mov ah, 0x86
	mov cx, 0x01
	mov dx, 0xE848
	int 0x15
	pop cx

	loop song_loop
	jmp play_song

clear_screen:
	; clear screen
	mov ah, 0x06
	mov al, 0
	mov bh, 0x1b
	mov cx, 0x0000
	mov dx, 0x184f
	int 0x10
	; reset cursor
	mov ah, 0x02
	mov bh, 0
	mov dx, 0x0000
	int 0x10
	ret

print_text:
	push si

	; compare note index
	mov bx, word [text_index]
	mov ax, [bx]
	add ax, song
	cmp ax, si
	jne .print_end

	; load text address to si and increment index
	mov si, word [text_index]
	mov si, [si + 2]
	add word [text_index], 4

	mov ah, 0x0e
	mov bh, 0
.char_loop:
	lodsb
	or al, al
	jz .print_end
	int 0x10
	jmp .char_loop
.print_end:
	pop si
	ret

text_index dw 0

text_maps:
	dw 0x0114, text01, 0x014c, text02, 0x018c, text03, 0x01cc, text04, 0x0208, text05, 0x0258, text06
	dw 0x0280, text07, 0x02a0, text08, 0x02c0, text09, 0x0300, text10, 0x0320, text11, 0x0340, text12
	dw 0x038c, text13, 0x03cc, text14, 0x03ec, text15, 0x040c, text16, 0x044c, text17, 0x0488, text18, 0x04d8, text19
	dw 0x0500, text07, 0x0520, text08, 0x0540, text09, 0x0580, text10, 0x05a0, text11, 0x05c0, text12
	dw 0x0600, text07, 0x0620, text08, 0x0640, text09, 0x0680, text10, 0x06a0, text11, 0x06c0, text12
	dw 0x078c, text23, 0x07cc, text23
	dw 0x080c, text13, 0x084c, text14, 0x086c, text15, 0x088c, text16, 0x08cc, text17, 0x0908, text20, 0x0958, text21
	dw 0x0980, text07, 0x09a0, text08, 0x09c0, text09, 0x0a00, text10, 0x0a20, text11, 0x0a40, text12
	dw 0x0a80, text07, 0x0aa0, text08, 0x0ac0, text09, 0x0b00, text10, 0x0b20, text11, 0x0b40, text12
	dw 0x0b80, text07, 0x0ba0, text08, 0x0bc0, text09, 0x0c00, text10, 0x0c20, text11, 0x0c40, text12

times 510-($-$$) db 0
dw 0xAA55

buffer:

text01 db "We're no strangers to love", 10, 13, 0
text02 db "You know the rules and so do I", 10, 13, 0
text03 db "A full commitment's what I'm thinking of", 10, 13, 0
text04 db "You wouldn't get this from any other guy", 10, 13, 0
text05 db "I just wanna tell you how I'm feeling", 10, 13, 0
text06 db "Gotta make you understand", 10, 13, 0

text07 db "Never gonna give you up", 10, 13, 0
text08 db "Never gonna let you down", 10, 13, 0
text09 db "Never gonna run around and desert you", 10, 13, 0
text10 db "Never gonna make you cry", 10, 13, 0
text11 db "Never gonna say goodbye", 10, 13, 0
text12 db "Never gonna tell a lie and hurt you", 10, 13, 0

text13 db "We've known each other for so long", 10, 13, 0
text14 db "Your heart's been aching but", 10, 13, 0
text15 db "You're too shy to say it", 10, 13, 0
text16 db "Inside we both know what's been going on", 10, 13, 0
text17 db "We know the game and we're gonna play it", 10, 13, 0

text18 db "And if you ask me how I'm feeling", 10, 13, 0
text19 db "Don't tell me you're too blind to see", 10, 13, 0
text20 db "I just wanna tell you how I'm feeling", 10, 13, 0
text21 db "Gotta make you understand", 10, 13, 0

text23 db "Never gonna give, never gonna give", 10, 13, 0

song:
incbin "utils/song.bin"

; align to sectors
times 4096+512-($-$$) db 0
