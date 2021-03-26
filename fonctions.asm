;------------------------------------------
; equivalent de strlen() en C
; fonction qui calcule la taille d'une string
slen:
    push    ebx
    mov     ebx, eax
 
nextchar:
    cmp     byte [eax], 0
    jz      finished
    inc     eax
    jmp     nextchar
 
finished:
    sub     eax, ebx
    pop     ebx
    ret
;------------------------------------------
; equivalent de printf
; fonction qui affiche une string à l'ecran
sprint:
    push    edx
    push    ecx
    push    ebx
    push    eax
    call    slen
 
    mov     edx, eax
    pop     eax
 
    mov     ecx, eax
    mov     ebx, 1
    mov     eax, 4
    int     80h
 
    pop     ebx
    pop     ecx
    pop     edx
    ret
;------------------------------------------
; void exit()
; Permet de mettre fin au programme
quit:
    mov     ebx, 0
    mov     eax, 1
    int     80h
    ret