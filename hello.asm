%include        'fonctions.asm'
 
SECTION .data
msg1        db      'Entrez votre nom : ', 0h      
msg2        db      'Salut ', 0h                       
 
SECTION .bss
sinput:     resb    255                                 
 
SECTION .text
global  _start
 
_start:
 
    mov     eax, msg1
    call    sprint
 
    mov     edx, 255        
    mov     ecx, sinput     
    mov     ebx, 0          
    mov     eax, 3          
    int     80h
 
    mov     eax, msg2
    call    sprint
 
    mov     eax, sinput     
    call    sprint          
 
    call    quit

    mov eax, 1          
    mov ebx, 0          
    int 80h             
