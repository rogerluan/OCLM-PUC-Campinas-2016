TITLE	proj1
.MODEL	SMALL
.STACK	100h
.DATA
    SYS_READ_CHAR equ 1 
    SYS_PRINT_STR equ 9
    ;SYS_PRINT_CHAR equ 2
    
    MENU DB 'a - AND', 10, 'b - OR', 10, 'c - XOR', 10, 'd - NOT', 10, 'e - Soma', 10, 'f - Subtracao', 10, 'g - Multiplicacao', 10, 'h - Divisao', 10, 'i - Mult por 2 N vezes', 10, 'j - Div por 2 N vezes', 10, 'k - Sair', 10, 'Opcao: $'

    BASE_CHOICE DB '', 10, 'Qual a base?', 10, 'a - Binario', 10, 'b - Decimal', 10, 'c - Hexadecimal', 10, 'Digite: $'

    ; NUM1 DW ?

    ;vectors
    VET DB 100 DUP("$")

    coordinate DW ?
    coord_x DW ?
    coord_y DW ?
    object_width DW 10
    object_height DW 10
    page_width DW 320

    ;objects
    alien1  DB 1,0,0,0,0,0,0,0,0,1
            DB 1,0,1,0,0,0,0,1,0,1
            DB 1,0,1,1,0,0,1,1,0,1
            DB 1,0,0,1,1,1,1,0,0,1
            DB 1,1,1,0,1,1,0,1,1,1
            DB 0,0,1,1,1,1,1,1,0,0
            DB 1,1,1,0,1,1,0,1,1,1
            DB 1,0,1,1,1,1,1,1,0,1
            DB 1,0,0,0,0,0,0,0,0,1
            DB 1,1,1,0,0,0,0,1,1,1

    alien2  DB 0,0,0,0,1,1,0,0,0,0
            DB 1,1,0,1,1,1,1,0,1,1
            DB 0,1,1,0,1,1,0,1,1,0
            DB 0,0,1,1,0,0,1,1,0,0
            DB 0,0,0,1,1,1,1,0,0,0
            DB 0,0,1,1,1,1,1,1,0,0
            DB 0,0,1,0,0,0,0,1,0,0
            DB 0,1,1,1,0,0,1,1,1,0
            DB 1,1,0,1,0,0,1,0,1,1
            DB 1,1,1,1,0,0,1,1,1,1

    alien3  DB 0,1,0,0,0,0,0,0,1,0
            DB 0,0,1,0,1,1,0,1,0,0
            DB 0,0,1,1,1,1,1,1,0,0
            DB 1,1,1,1,1,1,1,1,1,1
            DB 1,1,0,0,1,1,0,0,1,1
            DB 1,1,1,1,1,1,1,1,1,1
            DB 1,1,1,1,1,1,1,1,1,1
            DB 1,1,1,1,1,1,1,1,1,1
            DB 0,0,1,1,0,0,1,1,0,0
            DB 0,1,1,0,0,0,0,1,1,0

    boulder DB 1,1,1,1,1,1,1,1,1,1
            DB 1,0,1,0,1,1,0,1,0,1
            DB 1,1,0,1,0,0,1,0,1,1
            DB 1,0,1,0,1,1,0,1,0,1
            DB 1,1,0,1,0,0,1,0,1,1
            DB 1,0,1,0,1,1,0,1,0,1
            DB 1,1,0,1,0,0,1,0,1,1
            DB 1,0,1,0,1,1,0,1,0,1
            DB 1,1,0,1,0,0,1,0,1,1
            DB 1,1,1,1,1,1,1,1,1,1

    spaceship   DB 0,0,0,0,0,0,0,0,0,0
                DB 0,0,0,0,1,1,0,0,0,0
                DB 0,0,0,0,1,1,0,0,0,0
                DB 0,0,0,1,1,1,1,0,0,0
                DB 0,1,1,0,1,1,0,1,1,0
                DB 1,0,1,1,0,0,1,1,0,1
                DB 1,1,1,1,1,1,1,1,1,1
                DB 1,0,1,1,0,0,1,1,0,1
                DB 0,1,1,1,1,1,1,1,1,0
                DB 0,0,0,0,0,0,0,0,0,0

    blank_space DB 0,0,0,0,0,0,0,0,0,0
                DB 0,0,0,0,0,0,0,0,0,0
                DB 0,0,0,0,0,0,0,0,0,0
                DB 0,0,0,0,0,0,0,0,0,0
                DB 0,0,0,0,0,0,0,0,0,0
                DB 0,0,0,0,0,0,0,0,0,0
                DB 0,0,0,0,0,0,0,0,0,0
                DB 0,0,0,0,0,0,0,0,0,0
                DB 0,0,0,0,0,0,0,0,0,0
                DB 0,0,0,0,0,0,0,0,0,0

    game_matrix DB 32 DUP('0')
                DB 32 DUP('0')
                DB 32 DUP('0')
                DB 32 DUP('0')
                DB 32 DUP('0')
                DB 32 DUP('0')
                DB 32 DUP('0')
                DB 32 DUP('0')
                DB 32 DUP('0')
                DB 32 DUP('0')
                DB 32 DUP('0')
                DB 32 DUP('0')
                DB 32 DUP('0')
                DB 32 DUP('0')
                DB 32 DUP('0')
                DB 32 DUP('0')
                DB 32 DUP('0')
                DB 32 DUP('0')
                DB 32 DUP('0')
                DB 32 DUP('0')


.CODE
    mov ax, @DATA   ;prepare to use .DATA variables and constants
    mov ds, ax

    mov ax, 13h     ;change the video mode
    int 10h         ;interruption to apply the changes

    ; mov ax, 0A000h  ; The offset to video memory
    ; mov es, ax      ; We load it to ES through AX, cuz immediate operation is not allowed on ES
    jmp MAIN
    
; proc print_vector:
;     call push_all
;     cmp cx, 0
;     je print_vector_end
;     mov dl, vet[bx]
;     mov ah, 2
;     int 21H
;     inc bx
;     loop print_vector
; print_vector_end:
;     pop all
;     ret
; endp print_vector

; proc push_all
;     push ax
;     push bx
;     push cx
;     push dx
;     pushf
;     ret
; endp push_all

; proc pop_all
;     pop dx
;     pop cx
;     pop bx
;     pop ax
;     popf
;     ret
; endp pop_all

proc clear_screen
    mov ax, 13h     ;the argument here must be the current video mode
    int 10h
    ret
endp clear_screen

;print_object (object: si, x: coord_x, y: coord_y)
proc print_object
    mov cx, coord_x
    mov dx, coord_y

    print_object_loop:
        mov al, [si]
        mov ah, 0ch
        int 10h
        jmp print_object_increment
    print_object_increment:
        inc si
        inc cx
        mov bx, 10
        add bx, coord_x
        cmp bx, cx
        jne print_object_loop
    print_object_next_line:
        mov cx, coord_x
        inc dx
        mov bx, 10
        add bx, coord_y
        cmp bx, dx
        jne print_object_loop
    print_object_end:
        ret
endp print_object

proc print_aliens

    lea si, alien1      ;loads the alien1 in si register
    mov coord_x, 55     ;x parameter
    mov coord_y, 20     ;y parameter
    call print_object   ;prints the object in si register at the previously calculated coordinate

    lea si, alien2      ;loads the alien1 in si register
    mov coord_x, 70     ;x parameter
    mov coord_y, 20     ;y parameter
    call print_object   ;prints the object in si register at the previously calculated coordinate

    lea si, alien3      ;loads the alien1 in si register
    mov coord_x, 85     ;x parameter
    mov coord_y, 20     ;y parameter
    call print_object   ;prints the object in si register at the previously calculated coordinate

    lea si, boulder      ;loads the alien1 in si register
    mov coord_x, 100     ;x parameter
    mov coord_y, 20     ;y parameter
    call print_object   ;prints the object in si register at the previously calculated coordinate

    lea si, spaceship      ;loads the alien1 in si register
    mov coord_x, 115     ;x parameter
    mov coord_y, 20     ;y parameter
    call print_object   ;prints the object in si register at the previously calculated coordinate

    lea si, blank_space      ;loads the alien1 in si register
    mov coord_x, 130     ;x parameter
    mov coord_y, 20     ;y parameter
    call print_object   ;prints the object in si register at the previously calculated coordinate

    lea si, spaceship      ;loads the alien1 in si register
    mov coord_x, 145     ;x parameter
    mov coord_y, 20     ;y parameter
    call print_object   ;prints the object in si register at the previously calculated coordinate

    ret
endp print_aliens

proc print_boulders

    ret
endp print_boulders

proc print_spaceship

    ret
endp print_spaceship

MAIN:
    call print_aliens
    ; call print_boulders
    ; call print_spaceship

    mov ah, 1
    int 21h
    ; mov ax, 0 ; 0 will put it in top left corner. To put it in top right corner load with 320, in the middle of the screen 32010.

EXIT: 
    mov ax, 3       ;restore the video mode to original
    int 10h         
    mov ah, 4ch     ;end program
    int 21h

END