; Exemple de socket basique en listening mode qui acceptent les requetes valides 

; compilez avec nasm : nasm -f elf socket.asm
; linkez avec (64 bit systems require elf_i386 option): ld -m elf_i386 socket.o -o socket
; lancez avec : ./socket
 
%include    'fonctions.asm'
 
SECTION .bss
buffer resb 255,                ; variable pour stocker le header de la requete
 
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
 
    mov     edi, eax            ; on bind notre socket
    push    dword 0x00000000
    push    word 0x2923
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
 
    push    byte 1              ; on met notre socket en listening mode
    push    edi
    mov     ecx, esp
    mov     ebx, 4
    mov     eax, 102
    int     80h
 
_accept:
 
    push    byte 0              ; on accepte les requetes
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
 
    mov     edx, 255            ; nombre de bytes à lire (255 par defaut)
    mov     ecx, buffer         
    mov     ebx, esi            
    mov     eax, 3              
    int     80h                 
 
    mov     eax, buffer         
    call    sprintLF            
 
_exit:
 
    call    quit                ; appel de la fonction pour quitter