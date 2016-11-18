; useful functions

proc push_all
    push ax
    push bx
    push cx
    push dx
    pushf
    ret
endp push_all

proc pop_all
    pop dx
    pop cx
    pop bx
    pop ax
    popf
    ret
endp pop_all

proc clear_screen
    mov ax, 13h     ;the argument here must be the current video mode
    int 10h
    ret
endp clear_screen
