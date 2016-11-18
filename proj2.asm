TITLE	proj1
.MODEL	SMALL
.STACK	100h
.DATA
    SYS_READ_CHAR equ 1 
    SYS_PRINT_STR equ 9

    OBJECT_WIDTH equ 10
    OBJECT_HEIGHT equ 10
    SCREEN_WIDTH equ 320
    SCREEN_HEIGHT equ 200

    ID_BLANK equ 0
    ID_ALIEN1 equ 1
    ID_ALIEN2 equ 2
    ID_ALIEN3 equ 3
    ID_SPACESHIP equ 4
    ID_BULLET equ 5
    ID_BOULDER1 equ 6 
    ID_BOULDER2 equ 7 
    ID_BOULDER3 equ 8 

    INITIAL_SPACESHIP_POS equ 591 ;19th row, 16th column (18*32 + 15)
    LEFT_SPACESHIP_MARGIN equ 576 ;left wall position
    RIGHT_SPACESHIP_MARGIN equ 607 ;right wall position
    
    MENU DB 'a - AND', 10, 'b - OR', 10, 'c - XOR', 10, 'd - NOT', 10, 'e - Soma', 10, 'f - Subtracao', 10, 'g - Multiplicacao', 10, 'h - Divisao', 10, 'i - Mult por 2 N vezes', 10, 'j - Div por 2 N vezes', 10, 'k - Sair', 10, 'Opcao: $'

    BASE_CHOICE DB '', 10, 'Qual a base?', 10, 'a - Binario', 10, 'b - Decimal', 10, 'c - Hexadecimal', 10, 'Digite: $'

    coord_x DW 0
    coord_y DW 0
    spaceship_pos DW INITIAL_SPACESHIP_POS
    bullet_pos DW 0
    has_bullet DW 0
    score DW 0
    aliens_alive DW 60

    ;objects
    alien1  DB 7,0,0,0,0,0,0,0,0,7
            DB 7,0,7,0,0,0,0,7,0,7
            DB 7,0,7,7,0,0,7,7,0,7
            DB 7,0,0,7,7,7,7,0,0,7
            DB 7,7,7,0,7,7,0,7,7,7
            DB 0,0,7,7,7,7,7,7,0,0
            DB 7,7,7,0,7,7,0,7,7,7
            DB 7,0,7,7,7,7,7,7,0,7
            DB 7,0,0,0,0,0,0,0,0,7
            DB 7,7,7,0,0,0,0,7,7,7

    alien2  DB 0,0,0,0,6,6,0,0,0,0
            DB 6,6,0,6,6,6,6,0,6,6
            DB 0,6,6,0,6,6,0,6,6,0
            DB 0,0,6,6,0,0,6,6,0,0
            DB 0,0,0,6,6,6,6,0,0,0
            DB 0,0,6,6,6,6,6,6,0,0
            DB 0,0,6,0,0,0,0,6,0,0
            DB 0,6,6,6,0,0,6,6,6,0
            DB 6,6,0,6,0,0,6,0,6,6
            DB 6,6,6,6,0,0,6,6,6,6

    alien3  DB 0,4,0,0,0,0,0,0,4,0
            DB 0,0,4,0,4,4,0,4,0,0
            DB 0,0,4,4,4,4,4,4,0,0
            DB 4,4,4,4,4,4,4,4,4,4
            DB 4,4,0,0,4,4,0,0,4,4
            DB 4,4,4,4,4,4,4,4,4,4
            DB 4,4,4,4,4,4,4,4,4,4
            DB 4,4,4,4,4,4,4,4,4,4
            DB 0,0,4,4,0,0,4,4,0,0
            DB 0,4,4,0,0,0,0,4,4,0

    boulder1 DB 1,1,1,1,1,1,1,1,1,1
             DB 1,1,1,1,1,1,1,1,1,1
             DB 1,1,1,1,1,1,1,1,1,1
             DB 1,1,1,1,1,1,1,1,1,1
             DB 1,1,1,1,1,1,1,1,1,1
             DB 1,1,1,1,1,1,1,1,1,1
             DB 1,1,1,1,0,0,1,1,1,1
             DB 1,1,1,0,0,0,0,1,1,1
             DB 1,1,0,0,0,0,0,0,1,1
             DB 1,0,0,0,0,0,0,0,0,1

    boulder2 DB 1,1,1,1,1,1,1,1,1,1
             DB 1,0,1,0,1,0,1,0,1,1
             DB 1,1,0,1,0,1,0,1,0,1
             DB 1,0,1,0,1,0,1,0,1,1
             DB 1,1,0,1,0,1,0,1,0,1
             DB 1,0,1,0,1,0,1,0,1,1
             DB 1,1,0,1,0,0,0,1,0,1
             DB 1,0,1,0,0,0,0,0,1,1
             DB 1,1,0,0,0,0,0,0,0,1
             DB 1,0,0,0,0,0,0,0,0,1

    boulder3 DB 1,1,1,1,1,1,1,1,1,1
             DB 1,0,0,0,0,0,0,0,0,1
             DB 1,0,0,0,0,0,0,0,0,1
             DB 1,0,0,0,0,0,0,0,0,1
             DB 1,0,0,0,0,0,0,0,0,1
             DB 1,0,0,0,0,0,0,0,0,1
             DB 1,0,0,0,0,0,0,0,0,1
             DB 1,0,0,0,0,0,0,0,0,1
             DB 1,0,0,0,0,0,0,0,0,1
             DB 1,0,0,0,0,0,0,0,0,1

            ;
            ;
            ;
            ;
            ;
            ;
            ;
            ;
            ;            criar mais 2 boulders ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
            ;
            ;
            ;
            ;
            ;
            ;
            ;
            ;


    spaceship   DB 0,0,0,0,0,0,0,0,0,0
                DB 0,0,0,0,9,9,0,0,0,0
                DB 0,0,0,0,9,9,0,0,0,0
                DB 0,0,0,9,9,9,9,0,0,0
                DB 0,9,9,0,9,9,0,9,9,0
                DB 9,0,9,9,0,0,9,9,0,9
                DB 9,9,9,9,9,9,9,9,9,9
                DB 9,0,9,9,0,0,9,9,0,9
                DB 0,9,9,9,9,9,9,9,9,0
                DB 0,0,0,0,0,0,0,0,0,0

    bullet  DB 0,0,0,0,1,1,0,0,0,0
            DB 0,0,0,0,1,1,0,0,0,0
            DB 0,0,0,0,1,1,0,0,0,0
            DB 0,0,0,0,1,1,0,0,0,0
            DB 0,0,0,0,1,1,0,0,0,0
            DB 0,0,0,0,1,1,0,0,0,0
            DB 0,0,0,0,1,1,0,0,0,0
            DB 0,0,0,0,1,1,0,0,0,0
            DB 0,0,0,0,1,1,0,0,0,0
            DB 0,0,0,0,1,1,0,0,0,0

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

    game_matrix DB 32 DUP(0)
                DB 32 DUP(0)
                DB 32 DUP(0)
                DB 6 DUP(0), 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 7 DUP(0)
                DB 6 DUP(0), 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 7 DUP(0)
                DB 6 DUP(0), 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 7 DUP(0)
                DB 6 DUP(0), 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 7 DUP(0)
                DB 6 DUP(0), 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 7 DUP(0)
                DB 6 DUP(0), 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 7 DUP(0)
                DB 32 DUP(0)
                DB 32 DUP(0)
                DB 32 DUP(0)
                DB 32 DUP(0)
                DB 32 DUP(0)
                DB 32 DUP(0)
                DB 7 DUP(0), 9 DUP(6, 0), 7 DUP(0)
                DB 32 DUP(0)
                DB 32 DUP(0)
                DB 15 DUP(0), 4, 16 DUP(0)
                DB 32 DUP(0)

.CODE
    mov ax, @DATA   ;prepare to use .DATA variables and constants
    mov ds, ax

    mov ax, 13h     ;change the video mode
    int 10h         ;interruption to apply the changes

    jmp MAIN

MAIN:
    call print_matrix
    main_infinite_loop:
        call check_keystroke
        jmp main_infinite_loop

proc print_char_matrix

endp

proc print_matrix
    mov coord_x, 0 ;x coordinate
    mov coord_y, 0 ;y coordinate
    push bx
    mov bx, 0

    print_matrix_loop_init:
        mov al, game_matrix[bx]
        cmp al, ID_BLANK
        je print_matrix_blank
        cmp al, ID_ALIEN1
        je print_matrix_alien1
        cmp al, ID_ALIEN2
        je print_matrix_alien2
        cmp al, ID_ALIEN3
        je print_matrix_alien3
        cmp al, ID_BOULDER1
        je print_matrix_boulder1
        cmp al, ID_BOULDER2
        je print_matrix_boulder2
        cmp al, ID_BOULDER3
        je print_matrix_boulder3
        cmp al, ID_BULLET
        je print_matrix_bullet
        cmp al, ID_SPACESHIP
        je print_matrix_spaceship
        jmp print_matrix_end

        print_matrix_blank:
            lea si, blank_space
            jmp print_matrix_print_object
        print_matrix_alien1:
            lea si, alien1
            jmp print_matrix_print_object
        print_matrix_alien2:
            lea si, alien2
            jmp print_matrix_print_object
        print_matrix_alien3:
            lea si, alien3
            jmp print_matrix_print_object
        print_matrix_boulder1:
            lea si, boulder1
            jmp print_matrix_print_object
        print_matrix_boulder2:
            lea si, boulder2
            jmp print_matrix_print_object
        print_matrix_boulder3:
            lea si, boulder3
            jmp print_matrix_print_object
        print_matrix_spaceship:
            lea si, spaceship
            jmp print_matrix_print_object
        print_matrix_bullet:
            lea si, bullet

            print_matrix_print_object:
                call print_object
                inc bx ;increment
                add coord_x, OBJECT_WIDTH
                cmp coord_x, SCREEN_WIDTH
                je print_matrix_next_line
                jmp print_matrix_loop_init
                print_matrix_next_line:
                    sub coord_x, SCREEN_WIDTH
                    add coord_y, OBJECT_HEIGHT
                    cmp coord_y, SCREEN_HEIGHT
                    je print_matrix_end
                    jmp print_matrix_loop_init

    print_matrix_end:
        pop bx
        ret

endp print_matrix

proc check_keystroke
    mov ah, 01h ; checks if a key is pressed
    int 16h
    jz check_keystroke_end ; if zero, no key was pressed
    call did_press_key
    check_keystroke_end:
    ret
endp check_keystroke

proc did_press_key
    mov ah, 00h ; get the keystroke
    int 16h

    cmp al, 61h ;checks if key was `a`
    je did_press_key_move_left
    cmp al, 64h ;checks if key was `d`
    je did_press_key_move_right
    cmp al, 20h ;checks if key was SPACE
    je did_press_key_shooting
    cmp al, 1bh ;checks if key was ESC
    je did_press_key_quit_game
    did_press_key_move_left:
        cmp spaceship_pos, LEFT_SPACESHIP_MARGIN
        je did_press_key_end
        mov bx, spaceship_pos
        mov game_matrix[bx], ID_BLANK
        dec bx
        mov spaceship_pos, bx
        mov game_matrix[bx], ID_SPACESHIP
        jmp did_press_key_end
    did_press_key_move_right:
        cmp spaceship_pos, RIGHT_SPACESHIP_MARGIN
        je  did_press_key_end
        mov bx, spaceship_pos
        mov game_matrix[bx], ID_BLANK
        inc bx
        mov spaceship_pos, bx
        mov game_matrix[bx], ID_SPACESHIP
        jmp did_press_key_end
    did_press_key_shooting:
        cmp has_bullet, 1
        je  did_press_key_end
        call shoot_action    
        jmp did_press_key_end
    did_press_key_quit_game:
        jmp EXIT
    did_press_key_end:
        call print_matrix
        ret
endp did_press_key

proc shoot_action
    sub score, 5

    mov has_bullet, 1
    mov bx, spaceship_pos
    sub bx, 32
    cmp game_matrix[bx], ID_BLANK
    jne shoot_action_hit
    mov game_matrix[bx], ID_BULLET
    shoot_action_loop:
        call print_matrix
        mov game_matrix[bx], ID_BLANK
        sub bx, 32
        cmp game_matrix[bx], ID_BLANK
        jne shoot_action_hit
        cmp bx, 0
        jle shoot_action_loop_end
        mov game_matrix[bx], ID_BULLET
        jmp shoot_action_loop
        shoot_action_hit:
            cmp game_matrix[bx], ID_ALIEN3
            jle shoot_action_hit_alien
            cmp game_matrix[bx], ID_BOULDER1
            jge shoot_action_hit_boulder
            shoot_action_hit_alien:
            call did_hit_alien
            jmp shoot_action_loop_end
            shoot_action_hit_boulder:
            cmp game_matrix[bx], ID_BOULDER1
            je shoot_action_hit_boulder1
            cmp game_matrix[bx], ID_BOULDER2
            je shoot_action_hit_boulder2
            jmp shoot_action_hit_boulder3
                shoot_action_hit_boulder1:
                mov game_matrix[bx], ID_BOULDER2
                jmp shoot_action_loop_end
                shoot_action_hit_boulder2:
                mov game_matrix[bx], ID_BOULDER3
                jmp shoot_action_loop_end
                shoot_action_hit_boulder3:
                mov game_matrix[bx], ID_BLANK
                jmp shoot_action_loop_end
    shoot_action_loop_end:
        mov has_bullet, 0
        ret
endp shoot_action

proc did_hit_alien
    ;adds the correct alien score
    cmp game_matrix[bx], ID_ALIEN1
    je did_hit_alien1
    cmp game_matrix[bx], ID_ALIEN2
    je did_hit_alien2
    jmp did_hit_alien3
        did_hit_alien1:
            add score, 20
        did_hit_alien2:
            add score, 40
        did_hit_alien3:
            add score, 60
    mov game_matrix[bx], ID_BLANK

    ;decrements the aliens_alive counter
    dec aliens_alive

    ;checks if this was the last alien alive
    cmp aliens_alive, 0
    je did_hit_last_alien
    ret
    did_hit_last_alien:
    call game_over
endp did_hit_alien

proc game_over
    cmp aliens_alive, 0
    je game_over_win
    ;game lost

    game_over_win:


    ret
endp

proc delay
        mov cx, 003H
    delayRep: 
        push cx
        mov cx, 0D090H
    delayDec: 
        dec cx
        jnz delayDec
        pop cx
        dec cx
        jnz delayRep
        ret
endp delay

;print_object - si must contain the object to be printed
proc print_object
    mov cx, coord_x
    mov dx, coord_y
    push ax
    push bx
    print_object_loop:
        mov al, [si]
        mov ah, 0ch
        int 10h
        inc si ;increment to the next position
        inc cx
        mov bx, OBJECT_WIDTH
        add bx, coord_x
        cmp bx, cx
        jne print_object_loop
        print_object_next_line:
            mov cx, coord_x
            inc dx
            mov bx, OBJECT_HEIGHT
            add bx, coord_y
            cmp bx, dx
            jne print_object_loop
        pop bx
        pop ax
        ret
endp print_object

EXIT: 
    mov ax, 3       ;restore the video mode to original
    int 10h         
    mov ah, 4ch     ;end program
    int 21h

END