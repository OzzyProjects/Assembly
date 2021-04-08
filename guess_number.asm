; Qui suis-je version nombre

section .text

	global _start

_start:

	call __open
	mov ebx, _dev_random
	mov ecx, 0 
	call __syscall

	mov ebx, eax
	push eax
	call __read
	mov ecx, randint
	mov edx, 4 
	call __syscall
	
	call __close
	pop ebx
	call __syscall

	mov eax, [randint]
	jmp _modend

_modup:

	add eax, maxrand
	jmp _modend

_moddown:

	sub eax, maxrand

_modend:

	cmp eax, maxrand
	jg _moddown
	cmp eax, 1 
	jl _modup

	mov [randint], eax
	
	call __write
	mov ebx, 1 
	mov ecx, hello
	mov edx, hello_len
	call __syscall

_loop:

	mov eax, [tries]
	mov ebx, 1 
	mov ecx, 10 
	call __itoa_knowndigits
	
	mov ecx, eax
	mov edx, ebx
	
	call __write
	mov ebx, 1 
	call __syscall
	
	call __write
	mov ebx, 1 
	mov ecx, prompt
	mov edx, prompt_len
	call __syscall
	
	call __read
	mov ebx, 0 
	mov ecx, inputbuf
	mov edx, inputbuf_len
	call __syscall

	mov ecx, eax
	sub ecx, 1 
	
	cmp ecx, 1 
	jl _reenter

	mov ebx, ecx

	mov eax, 0 
	jmp _loopconvert_nomul

_loopconvert:

	imul eax, 10 
	
_loopconvert_nomul:

	mov edx, ebx
	sub edx, ecx
	
	push eax
	
	mov ah, [inputbuf+edx]
	
	sub ah, 48 
	
	cmp ah, 0 
	jl _reenter
	cmp ah, 9 
	jg _reenter

	movzx edx, ah
	
	pop eax
	add eax, edx

	loop _loopconvert
	
	jmp _convertok

_reenter:

	call __write
	mov ebx, 1 
	mov ecx, reenter
	mov edx, reenter_len
	call __syscall
	jmp _loop
	
_toohigh:

	call __write
	mov ebx, 1 
	mov ecx, toohigh
	mov edx, toohigh_len
	call __syscall

	jmp _again

_toolow:
	
	call __write
	mov ebx, 1 
	mov ecx, toolow
	mov edx, toolow_len
	call __syscall

_again:

	cmp dword [tries], 1 
	jle _lose

	sub dword [tries], 1 
	
	jmp _loop

_lose:

	call __write
	mov ebx, 1 
	mov ecx, youlose
	mov edx, youlose_len
	call __syscall

	mov eax, [randint]
	call __itoa

	mov ecx, eax
	mov edx, ebx
	call __write
	mov ebx, 1 
	call __syscall

	call __write
	mov ebx, 1 
	mov ecx, youlose2
	mov edx, youlose2_len
	call __syscall

	mov ebx, 2 

	jmp _exit

_convertok:

	cmp eax, [randint]
	jg _toohigh
	jl _toolow

	call __write
	mov ebx, 1 
	mov ecx, youwin
	mov edx, youwin_len
	call __syscall

	mov ebx, 1 

_exit:

	push ebx

	call __write
	mov ebx, 1 
	mov ecx, goodbye
	mov edx, goodbye_len
	call __syscall
	mov ebx, 2 
	call __syscall

	call __write
	mov ebx, 1 
	mov ecx, _ok
	mov edx, _ok_len
	call __syscall
	mov ebx, 2 
	call __syscall

	call __exit
	pop ebx
	call __syscall
	


__itoa_init:

	pop dword [_itoabuf]

	push ecx
	push edx

	push dword [_itoabuf]
	
	ret

__itoa: 

	call __itoa_init

	mov ecx, 10 
	mov ebx, 1 

__itoa_loop:

	cmp eax, ecx
	jl __itoa_loopend

	imul ecx, 10 
	add ebx, 1 
	jmp __itoa_loop

__itoa_knowndigits: 

	call __itoa_init

__itoa_loopend:

	mov edx, ecx
	mov ecx, ebx
	
	push ebx

__itoa_loop2:

	push eax
	mov eax, edx
	mov edx, 0 
	mov ebx, 10 

	idiv ebx
	mov ebx, eax 
	
	mov eax, [esp] 
	mov edx, 0 
	idiv ebx 

	mov edx, [esp+4] 
	sub edx, ecx
	
	add eax, 48 
	
	mov [_itoabuf+edx], eax

	sub eax, 48 

	imul eax, ebx

	mov edx, ebx 
	
	pop ebx 
	sub ebx, eax 
	mov eax, ebx	

	loop __itoa_loop2

	mov eax, _itoabuf
	pop ebx
    pop edx
	pop ecx	

	ret

__exit:
	
	mov eax, 1 
	ret

__read:

	mov eax, 3 
	ret

__write:
	
	mov eax, 4 
	ret

__open:

	mov eax, 5 
	ret

__close:

	mov eax, 6 
	ret

__syscall:

	int 0x80 
	ret

section .data

	_dev_random db "/dev/random", 0x0
	
	maxrand equ 100
	tries dd 6

	prompt db " essais restants. Nombre à entrer (1-100): "
	prompt_len equ $-prompt

	hello db 0xa, "Je suis un nombre entre 1 et 100 mais lequel ?", 0xa, 0xa
	hello_len equ $-hello

	reenter db "? Retapez", 0xa, "Entree invalide : il faut un integer", 0xa
	reenter_len equ $-reenter

	toohigh db "Trop haut !", 0xa, 0xa
	toohigh_len equ $-toohigh

	toolow db "Trop bas !", 0xa, 0xa
	toolow_len equ $-toolow

	youwin db 0x7, 0xa, "#^$&^@%#^@#! C'est exact ! Vous avez gagné !", 0xa, 0xa
	youwin_len equ $-youwin

	youlose db "Vous n'avez plus d'essai!", 0xa, "La reponse etait "
	youlose_len equ $-youlose

	youlose2 db "! Mwahahah!", 0xa, 0xa
	youlose2_len equ $-youlose2

	goodbye db "Goodbye.", 0xa
	goodbye_len equ $-goodbye

	_ok db "Exit OK", 0xa, 0xa
	_ok_len equ $-_ok

section .bss

	randint resw 2
	downsize resw 2
	
	_itoabuf resb 1024

	inputbuf resb 1024
	inputbuf_len equ 1024
