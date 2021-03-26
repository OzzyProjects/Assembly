;------------------------------------------
; fonction qui affiche un integer
;------------------------------------------
iprint:
    push    eax             
    push    ecx             
    push    edx             
    push    esi             
    mov     ecx, 0          
 
divideLoop:
    inc     ecx             
    mov     edx, 0          
    mov     esi, 10         
    idiv    esi             
    add     edx, 48         
    push    edx             
    cmp     eax, 0          
    jnz     divideLoop      
 
printLoop:
    dec     ecx             
    mov     eax, esp        
    call    sprint         
    pop     eax            
    cmp     ecx, 0         
    jnz     printLoop      
 
    pop     esi            
    pop     edx            
    pop     ecx            
    pop     eax            
    ret
 
 
;------------------------------------------
; fonction qui print un integer avec retour à la ligne
;------------------------------------------
iprintLF:
    call    iprint         
 
    push    eax            
    mov     eax, 0Ah       
    push    eax            
    mov     eax, esp       
    call    sprint         
    pop     eax            
    pop     eax            
    ret
 
 
;------------------------------------------
; fonction qui calcule la taille d'une chaine de caracteres
; strlen() en C
;------------------------------------------
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
; fonction qui affiche une chaine de caracteres
;------------------------------------------
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
; fonction qui affiche une chaine de caracteres avec retour à la ligne
;------------------------------------------
sprintLF:
    call    sprint
 
    push    eax
    mov     eax, 0AH
    push    eax
    mov     eax, esp
    call    sprint
    pop     eax
    pop     eax
    ret
 
 
;------------------------------------------
; fonction qui quitte le programme
;------------------------------------------
quit:
    mov     ebx, 0
    mov     eax, 1
    int     80h
    ret
