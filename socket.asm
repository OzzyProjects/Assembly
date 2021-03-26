; Socket
; compilez avec nasm : nasm -f elf socket.asm
; linkez avec (64 bit systems require elf_i386 option): ld -m elf_i386 socket.o -o socket
; Run with: ./socket
 
%include    'fonctions.asm'
 
SECTION .data
; notre reponse HTTP
response db 'HTTP/1.1 200 OK', 0Dh, 0Ah, 'Content-Type: text/html', 0Dh, 0Ah, 'Content-Length: 14', 0Dh, 0Ah, 0Dh, 0Ah, 'Hello World!', 0Dh, 0Ah, 0h
 
SECTION .bss
buffer resb 255,                ; variable pour stocker les headers de la requete
 
SECTION .text
global  _start
 
_start:
 
    xor     eax, eax            ; on initialise les registres
    xor     ebx, ebx
    xor     edi, edi
    xor     esi, esi
 
_socket:
 
    push    byte 6              ; on crée notre socket
    push    byte 1
    push    byte 2
    mov     ecx, esp
    mov     ebx, 1
    mov     eax, 102
    int     80h
 
_bind:
 
    mov     edi, eax            ; on bind notre socket sur le port 9001
    push    dword 0x00000000
    push    word 0x2923         ; ecriture de 9001 en hexadecimal reverse bytes order
    push    word 2
    mov     ecx, esp
    push    byte 16
    push    ecx
    push    edi
    mov     ecx, esp
    mov     ebx, 2
    mov     eax, 102
    int     80h
 
_listen:
 
    push    byte 1              ; on met le socket en mode listening
    push    edi
    mov     ecx, esp
    mov     ebx, 4
    mov     eax, 102
    int     80h
 
_accept:
 
    push    byte 0              
    push    byte 0
    push    edi
    mov     ecx, esp
    mov     ebx, 5
    mov     eax, 102
    int     80h
 
_fork:
 
    mov     esi, eax            
    mov     eax, 2
    int     80h
 
    cmp     eax, 0
    jz      _read
 
    jmp     _accept
 
_read:
 
    mov     edx, 255            
    mov     ecx, buffer
    mov     ebx, esi
    mov     eax, 3
    int     80h
 
    mov     eax, buffer
    call    sprintLF
 
_write:
 
    mov     edx, 78             
    mov     ecx, response
    mov     ebx, esi
    mov     eax, 4
    int     80h
 
_close:
 
    mov     ebx, esi            ; on met esi dans ebx (accepted socket file descriptor)
    mov     eax, 6              ; on invoke SYS_CLOSE (kernel opcode 6)
    int     80h                 ; on fait appel au kernel
 
_exit:
 
    call    quit                ; call our quit function