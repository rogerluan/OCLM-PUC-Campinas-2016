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
    ID_BOULDER4 equ 9
    ID_BOULDER5 equ 10
    ID_DESTROYED_SPACESHIP equ 11

    TOTAL_ALIENS equ 60
    SHOOT_SCORE_COST equ 5
    ALIEN_SCORE equ 20

    INITIAL_SPACESHIP_POS equ 591 ;19th row, 16th column (18*32 + 15)
    LEFT_SPACESHIP_MARGIN equ 576 ;left wall position
    RIGHT_SPACESHIP_MARGIN equ 607 ;right wall position

    STATUS_BAR DB 'Lives:                      Score:      $'
    GAME_OVER_WIN_MSG DB '                You won!', 10, 10, 10, 10, '           Press ESC to quit,', 10,'           or any other key', 10,'            to play again.$'
    GAME_OVER_LOSE_MSG DB '          Game over! You lost.', 10, 10, '           Press ESC to quit,', 10,'           or any other key', 10,'            to play again.$'

    coord_x DW 0
    coord_y DW 0
    spaceship_pos DW INITIAL_SPACESHIP_POS
    bullet_pos DW 0
    has_bullet DW 0
    score DW 0
    aliens_alive DW TOTAL_ALIENS
    lives DW 3
    matrix_index DW 0

    ;objects
    alien1  DB 10,0,0,0,0,0,0,0,0,10
            DB 10,0,10,0,0,0,0,10,0,10
            DB 10,0,10,10,0,0,10,10,0,10
            DB 10,0,0,10,10,10,10,0,0,10
            DB 10,10,10,0,10,10,0,10,10,10
            DB 0,0,10,10,10,10,10,10,0,0
            DB 10,10,10,0,10,10,0,10,10,10
            DB 10,0,10,10,10,10,10,10,0,10
            DB 10,0,0,0,0,0,0,0,0,10
            DB 10,10,10,0,0,0,0,10,10,10

    alien2  DB 0,0,0,0,14,14,0,0,0,0
            DB 14,14,0,14,14,14,14,0,14,14
            DB 0,14,14,0,14,14,0,14,14,0
            DB 0,0,14,14,0,0,14,14,0,0
            DB 0,0,0,14,14,14,14,0,0,0
            DB 0,0,14,14,14,14,14,14,0,0
            DB 0,0,14,0,0,0,0,14,0,0
            DB 0,14,14,14,0,0,14,14,14,0
            DB 14,14,0,14,0,0,14,0,14,14
            DB 14,14,14,14,0,0,14,14,14,14

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

    boulder1 DB 6,6,6,6,6,6,6,6,6,6
             DB 6,6,6,6,6,6,6,6,6,6
             DB 6,6,6,6,6,6,6,6,6,6
             DB 6,6,6,6,6,6,6,6,6,6
             DB 6,6,6,6,6,6,6,6,6,6
             DB 6,6,6,6,6,6,6,6,6,6
             DB 6,6,6,6,0,0,6,6,6,6
             DB 6,6,6,0,0,0,0,6,6,6
             DB 6,6,0,0,0,0,0,0,6,6
             DB 6,0,0,0,0,0,0,0,0,6

    boulder2 DB 6,6,6,6,6,6,6,6,6,6
             DB 6,0,6,0,6,0,6,0,6,6
             DB 6,6,0,6,0,6,0,6,0,6
             DB 6,0,6,0,6,0,6,0,6,6
             DB 6,6,0,6,0,6,0,6,0,6
             DB 6,0,6,0,6,0,6,0,6,6
             DB 6,6,0,6,0,0,0,6,0,6
             DB 6,0,6,0,0,0,0,0,6,6
             DB 6,6,0,0,0,0,0,0,0,6
             DB 6,0,0,0,0,0,0,0,0,6

    boulder3 DB 6,6,6,6,6,6,6,6,6,6
             DB 6,0,0,0,0,0,0,0,0,6
             DB 6,0,0,0,0,0,0,0,0,6
             DB 6,0,0,0,0,0,0,0,0,6
             DB 6,0,0,0,0,0,0,0,0,6
             DB 6,0,0,0,0,0,0,0,0,6
             DB 6,0,0,0,0,0,0,0,0,6
             DB 6,0,0,0,0,0,0,0,0,6
             DB 6,0,0,0,0,0,0,0,0,6
             DB 6,0,0,0,0,0,0,0,0,6

    boulder4 DB 6,0,6,0,6,0,6,0,6,0
             DB 0,0,0,0,0,0,0,0,0,6
             DB 6,0,0,0,0,0,0,0,0,0
             DB 0,0,0,0,0,0,0,0,0,6
             DB 6,0,0,0,0,0,0,0,0,0
             DB 0,0,0,0,0,0,0,0,0,6
             DB 6,0,0,0,0,0,0,0,0,0
             DB 0,0,0,0,0,0,0,0,0,6
             DB 6,0,0,0,0,0,0,0,0,0
             DB 0,0,0,0,0,0,0,0,0,6

    boulder5 DB 6,0,6,0,6,0,6,0,6,0
             DB 0,0,0,0,0,0,0,0,0,0
             DB 0,0,0,0,0,0,0,0,0,0
             DB 0,0,0,0,0,0,0,0,0,0
             DB 0,0,0,0,0,0,0,0,0,0
             DB 0,0,0,0,0,0,0,0,0,0
             DB 0,0,0,0,0,0,0,0,0,0
             DB 0,0,0,0,0,0,0,0,0,0
             DB 0,0,0,0,0,0,0,0,0,0
             DB 0,0,0,0,0,0,0,0,0,0

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

    destroyed_spaceship DB 9,0,0,9,0,0,9,0,0,9
                        DB 0,9,0,0,9,9,0,0,9,0
                        DB 0,0,9,0,9,9,0,9,0,0
                        DB 9,9,0,9,0,0,9,0,9,9
                        DB 0,0,9,0,9,9,0,9,0,0
                        DB 0,0,9,0,9,9,0,9,0,0
                        DB 9,9,0,9,0,0,9,0,9,9
                        DB 0,0,9,0,9,9,0,9,0,0
                        DB 0,9,0,0,9,9,0,0,9,0
                        DB 9,0,0,9,0,0,9,0,0,9

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
                DB 32 DUP(0)
                DB 32 DUP(0)
                DB 32 DUP(0)
                DB 32 DUP(0)
                DB 32 DUP(0)
                DB 32 DUP(0)
                DB 32 DUP(0)
                DB 32 DUP(0)
                DB 32 DUP(0)
                DB 32 DUP(0)
                DB 32 DUP(0)
                DB 32 DUP(0)
                DB 32 DUP(0)
                DB 32 DUP(0)
                DB 32 DUP(0)
                DB 32 DUP(0)
                DB 32 DUP(0)

    game_matrix_init    DB 32 DUP(0)
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
    int 10h
    jmp MAIN

MAIN:
    call restart_game

    ;infinite loop that constantly checks for keystrokes
    main_infinite_loop:
        call alien_random_shoot
        call check_keystroke
        jmp main_infinite_loop

;reset all the game information back to the game start
proc restart_game
    push ax
    push bx
    call clear_screen
    mov bx, 0
    restart_game_reset_matrix_loop:
        mov al, game_matrix_init[bx]
        mov game_matrix[bx], al
        inc bx
        cmp bx, 640
        jne restart_game_reset_matrix_loop
    ;reset all the game info
    mov spaceship_pos, INITIAL_SPACESHIP_POS
    mov has_bullet, 0
    mov score, 0
    mov lives, 3
    mov aliens_alive, TOTAL_ALIENS
    call refresh_screen
    pop bx
    pop ax
    ret
endp restart_game

;prints the whole matrix and status bar
proc refresh_screen
    call print_matrix
    call print_status_bar
    ret
endp refresh_screen

;prints the status bar (which includes the player's lives and score)
proc print_status_bar
    push bx

    ;moves the cursor to coordinate (0,0)
    mov ah, 2h
    mov bh, 0
    mov dh, 0
    mov dl, 0
    int 10h

    ;prints status bar
    lea dx, STATUS_BAR
    mov ah, SYS_PRINT_STR
    int 21h

    ;moves the cursor to coordinate (35,0)
    mov ah, 2h
    mov bh, 0
    mov dh, 0
    mov dl, 35
    int 10h

    ;prints score
    mov bx, score
    call output_decimal

    ;prints lives
    mov bx, 55
    mov cx, lives
    cmp cx, 0
    jle print_status_bar_end
    print_status_bar_loop:
        mov coord_x, bx
        mov coord_y, 0
        lea si, spaceship
        call print_object
        add bx, 15
        loop print_status_bar_loop
    print_status_bar_end:
    pop bx
    ret
endp print_status_bar

;procedure imported from proj1.asm
proc output_decimal ;reads the number from bx
    mov ax, bx
    push ax
    push bx
    push cx
    push dx
    or ax, ax
    jge output_decimal_pt1
    push ax
    mov dl, '-'
    mov ah, 2h
    int 21h
    pop ax
    neg ax
    output_decimal_pt1:
        xor cx, cx
        mov bx, 10
    output_decimal_pt2:
        xor dx, dx
        div bx
        push dx
        inc cx
        or ax, ax
        jne output_decimal_pt2
        mov ah, 2h
    output_decimal_pt3:
        pop dx
        add dl, 30h
        int 21h
        loop output_decimal_pt3
    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp output_decimal

;updates a single element of the matrix (which must be stored in BX)
proc update_matrix_at_index
    call get_coordinate_by_index
    call read_matrix_object
    call print_object
    ret
endp update_matrix_at_index

;calculates the (x,y) coordinates for a given matrix index (which must be stored in BX)
proc get_coordinate_by_index
    push ax
    push cx
    push dx
    xor ax, ax
    xor dx, dx

    mov ax, bx
    mov cx, 32
    div cx ; ax(matrix_index) <- ax(matrix_index) / cx(32)

    mov cx, 10
    push ax
    mov ax, dx
    mul cx ; ax <- ax*cx
    mov coord_x, ax
    xor dx, dx
    pop ax
    mul cx
    mov coord_y, ax

    pop dx
    pop cx
    pop ax
    ret
endp get_coordinate_by_index

;prints the whole matrix 
proc print_matrix
    mov coord_x, 0 ;x coordinate
    mov coord_y, 0 ;y coordinate
    push bx
    mov bx, 0

    print_matrix_loop_init:
        call read_matrix_object
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

;loads SI with the object contained in a given matrix index (which must be stored in BX)
proc read_matrix_object
    mov al, game_matrix[bx]
    cmp al, ID_BLANK
    je read_matrix_object_blank
    cmp al, ID_ALIEN1
    je read_matrix_object_alien1
    cmp al, ID_ALIEN2
    je read_matrix_object_alien2
    cmp al, ID_ALIEN3
    je read_matrix_object_alien3
    cmp al, ID_BOULDER1
    je read_matrix_object_boulder1
    cmp al, ID_BOULDER2
    je read_matrix_object_boulder2
    cmp al, ID_BOULDER3
    je read_matrix_object_boulder3
    cmp al, ID_BOULDER4
    je read_matrix_object_boulder4
    cmp al, ID_BOULDER5
    je read_matrix_object_boulder5
    cmp al, ID_BULLET
    je read_matrix_object_bullet
    cmp al, ID_SPACESHIP
    je read_matrix_object_spaceship
    cmp al, ID_DESTROYED_SPACESHIP
    je read_matrix_object_destroyed_spaceship
    jmp read_matrix_object_end

    read_matrix_object_blank:
        lea si, blank_space
        jmp read_matrix_object_end
    read_matrix_object_alien1:
        lea si, alien1
        jmp read_matrix_object_end
    read_matrix_object_alien2:
        lea si, alien2
        jmp read_matrix_object_end
    read_matrix_object_alien3:
        lea si, alien3
        jmp read_matrix_object_end
    read_matrix_object_boulder1:
        lea si, boulder1
        jmp read_matrix_object_end
    read_matrix_object_boulder2:
        lea si, boulder2
        jmp read_matrix_object_end
    read_matrix_object_boulder3:
        lea si, boulder3
        jmp read_matrix_object_end
    read_matrix_object_boulder4:
        lea si, boulder4
        jmp read_matrix_object_end
    read_matrix_object_boulder5:
        lea si, boulder5
        jmp read_matrix_object_end
    read_matrix_object_spaceship:
        lea si, spaceship
        jmp read_matrix_object_end
    read_matrix_object_destroyed_spaceship:
        lea si, destroyed_spaceship
        jmp read_matrix_object_end
    read_matrix_object_bullet:
        lea si, bullet
    read_matrix_object_end:
    ret
endp read_matrix_object

;prints the object contained in SI, at (coord_x, coord_y) coordinates
proc print_object
    push ax
    push bx
    push cx
    push dx
    mov cx, coord_x
    mov dx, coord_y
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
    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp print_object

;checks if any key was pressed
proc check_keystroke
    mov ah, 01h ; checks if a key is pressed
    int 16h
    jz check_keystroke_end ; if zero, no key was pressed
    call did_press_key
    check_keystroke_end:
    ret
endp check_keystroke

;action for a key press
proc did_press_key
    mov ah, 00h ; get the keystroke
    int 16h

    cmp al, 'a'
    je did_press_key_move_left
    cmp al, 'd'
    je did_press_key_move_right
    cmp al, 20h ;checks if key was SPACE
    je did_press_key_shooting
    cmp al, 1bh ;checks if key was ESC
    je did_press_key_quit_game
    jmp did_press_key_end
    did_press_key_move_left:
        cmp spaceship_pos, LEFT_SPACESHIP_MARGIN
        je did_press_key_end
        mov bx, spaceship_pos
        mov game_matrix[bx], ID_BLANK
        call update_matrix_at_index
        dec bx
        mov spaceship_pos, bx
        mov game_matrix[bx], ID_SPACESHIP
        call update_matrix_at_index
        call print_status_bar
        jmp did_press_key_end
    did_press_key_move_right:
        cmp spaceship_pos, RIGHT_SPACESHIP_MARGIN
        je did_press_key_end
        mov bx, spaceship_pos
        mov game_matrix[bx], ID_BLANK
        call update_matrix_at_index
        inc bx
        mov spaceship_pos, bx
        mov game_matrix[bx], ID_SPACESHIP
        call update_matrix_at_index
        call print_status_bar
        jmp did_press_key_end
    did_press_key_shooting:
        cmp has_bullet, 1
        je did_press_key_end
        call shoot_action
        call print_status_bar
        jmp did_press_key_end
    did_press_key_quit_game:
        jmp EXIT
    did_press_key_end:
        ret
endp did_press_key

;action for a shot
proc shoot_action
    sub score, SHOOT_SCORE_COST

    mov has_bullet, 1
    mov bx, spaceship_pos
    sub bx, 32
    cmp game_matrix[bx], ID_BLANK
    jne shoot_action_hit
    mov game_matrix[bx], ID_BULLET
    call update_matrix_at_index
    shoot_action_loop:
        call delay
        mov game_matrix[bx], ID_BLANK
        call update_matrix_at_index
        sub bx, 32
        cmp game_matrix[bx], ID_BLANK
        jne shoot_action_hit
        cmp bx, 0
        jle shoot_action_loop_end
        mov game_matrix[bx], ID_BULLET
        call update_matrix_at_index
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
            mov al, game_matrix[bx]
            cmp al, ID_BOULDER5
            je shoot_action_hit_boulder5
            inc al
            mov game_matrix[bx], al
            ; call update_matrix_at_index
            jmp shoot_action_loop_end
                shoot_action_hit_boulder5:
                mov game_matrix[bx], ID_BLANK
                ; call update_matrix_at_index
                jmp shoot_action_loop_end
    shoot_action_loop_end:
        call update_matrix_at_index
        mov has_bullet, 0
        ret
endp shoot_action

;action for an alien hit
proc did_hit_alien
    ;adds the correct alien score
    cmp game_matrix[bx], ID_ALIEN1
    je did_hit_alien1
    cmp game_matrix[bx], ID_ALIEN2
    je did_hit_alien2
    jmp did_hit_alien3
    did_hit_alien3:
        add score, ALIEN_SCORE
    did_hit_alien2:
        add score, ALIEN_SCORE
    did_hit_alien1:
        add score, ALIEN_SCORE
    mov game_matrix[bx], ID_BLANK

    ;decrements the aliens_alive counter
    dec aliens_alive

    ;checks if this was the last alien alive
    cmp aliens_alive, 0
    je did_hit_last_alien
    jmp did_hit_alien_end
    did_hit_last_alien:
        call game_over
    did_hit_alien_end:
    ret
endp did_hit_alien

;action for a spaceship hit
proc did_hit_spaceship
    cmp lives, 0
    jg did_hit_spaceship_decrement_life
    call game_over
    jmp did_hit_spaceship_end
    did_hit_spaceship_decrement_life:
    dec lives
    call print_status_bar
    call destroy_spaceship
    mov spaceship_pos, INITIAL_SPACESHIP_POS
    mov game_matrix[INITIAL_SPACESHIP_POS], ID_SPACESHIP
    mov bx, INITIAL_SPACESHIP_POS
    did_hit_spaceship_end:
    ret
endp did_hit_spaceship

;animates the spaceship destruction
proc destroy_spaceship
    mov game_matrix[bx], ID_DESTROYED_SPACESHIP
    call update_matrix_at_index
    call sleep250ms
    mov game_matrix[bx], ID_SPACESHIP
    call update_matrix_at_index
    call sleep250ms
    mov game_matrix[bx], ID_DESTROYED_SPACESHIP
    call update_matrix_at_index
    call sleep250ms
    mov game_matrix[bx], ID_BLANK
    call update_matrix_at_index
    call sleep250ms
    call sleep250ms
    call sleep250ms
    call sleep250ms
    ret
endp destroy_spaceship

;prints the game over screen and receives the player decision to play again or quit
proc game_over
    call print_game_over
    mov ah, 1
    int 21h
    cmp al, 1bh
    je game_over_decision_quit
    jmp game_over_decision_continue
    game_over_decision_quit:
        jmp EXIT
    game_over_decision_continue:
        call restart_game
    ret
endp game_over

;prints the game ove screen
proc print_game_over
    call clear_screen
    
    ;moves the cursor to coordinate (0,10)
    mov ah, 2h
    mov bh, 0
    mov dh, 10
    mov dl, 0
    int 10h

    mov ah, SYS_PRINT_STR

    cmp aliens_alive, 0
    je print_game_over_win
    lea dx, GAME_OVER_LOSE_MSG
    int 21h
    jmp print_game_over_end
    print_game_over_win:
        lea dx, GAME_OVER_WIN_MSG
        int 21h
    print_game_over_end:
    ret
endp print_game_over

;randomizes a chance that the nearest alien will shoot at the spaceship
proc alien_random_shoot
    call random_number
    cmp al, 1
    jge alien_random_shoot_end
    mov ax, spaceship_pos
    mov cx, 32
    div cx ; ax <- spaceship_pos/32; dx<-rest
    cmp dx, 6
    jle alien_random_shoot_row1
    cmp dx, 24
    jge alien_random_shoot_row10
    jmp alien_random_shoot_below_aliens
    alien_random_shoot_row1:
        mov dx, 6
        jmp alien_random_shoot_unshielded
    alien_random_shoot_row10:
        mov dx, 24
        jmp alien_random_shoot_unshielded
    alien_random_shoot_below_aliens:
        ;parity flag jump didn't work here. Idk why.
        mov al, dl
        and al, 00000001b ;check if the column number is odd/pair
        cmp al, 0
        je alien_random_shoot_unshielded
        push dx
        call random_number
        pop dx
        cmp al, 5
        jge alien_random_shoot_below_aliens_right_alien
        dec dx ;dx holds the matrix column index to be fired
        jmp alien_random_shoot_unshielded
        alien_random_shoot_below_aliens_right_alien:
        inc dx
        alien_random_shoot_unshielded:
        call calculate_lowest_alien_position
        sub bx, 32 ;check if there is an alien to shoot in that row
        cmp game_matrix[bx], ID_BLANK ;if there isn't, it shouldn't shoot
        je alien_random_shoot_end
        add bx, 32 ;if there is, shoot :)
        call fire_alien_shoot
    alien_random_shoot_end:
    ret
endp alien_random_shoot

;generates a random number between 0-9 (and place it in al)
proc random_number
    ;interruption to get time
    ;ch <- hours (0-23)
    ;cl <- minutes (0-59)
    ;dh <- seconds (0-59)
    ;dl <- hundredths (0-99)
    mov ah, 2ch
    int 21h
    mov al, dl
    xor dx, dx
    cbw
    mov bx, 10
    div bx ;al <- random number 0-9
    ret
endp random_number

;calculates the lowest alien position, position which must be held in dx
proc calculate_lowest_alien_position
    mov bx, dx
    add bx, 96                              ;starts the comparison at the 4th row because it's the highest alien position
    mov cx, 5                               ;max number of loops, because there're max 6 rows of aliens
    cmp game_matrix[bx], ID_BLANK
    je calculate_lowest_alien_position_end  ;there're no aliens in that row at all
    calculate_lowest_alien_position_loop:
    add bx, 32
    cmp game_matrix[bx], ID_BLANK
    je calculate_lowest_alien_position_end
    dec cx
    loop calculate_lowest_alien_position_loop
    add bx, 32                              ;performance increase
    calculate_lowest_alien_position_end:
    ret
endp

;fires a shot from a given index (which is stored in matrix_index)
proc fire_alien_shoot
    cmp game_matrix[bx], ID_BLANK
    jne fire_alien_shoot_hit
    mov game_matrix[bx], ID_BULLET
    call update_matrix_at_index
    fire_alien_shoot_loop:
        call delay
        mov game_matrix[bx], ID_BLANK
        call update_matrix_at_index
        add bx, 32
        cmp game_matrix[bx], ID_BLANK
        jne fire_alien_shoot_hit
        cmp bx, 640
        jge fire_alien_shoot_loop_end
        mov game_matrix[bx], ID_BULLET
        call update_matrix_at_index
        jmp fire_alien_shoot_loop
    fire_alien_shoot_hit:
        cmp game_matrix[bx], ID_BOULDER1
        jge fire_alien_shoot_hit_boulder
        fire_alien_shoot_hit_spaceship:
        call did_hit_spaceship
        call update_matrix_at_index
        jmp fire_alien_shoot_loop_end
        fire_alien_shoot_hit_boulder:
        mov al, game_matrix[bx]
        cmp al, ID_BOULDER5
        je fire_alien_shoot_hit_boulder5
        inc al
        mov game_matrix[bx], al
        call update_matrix_at_index
        jmp fire_alien_shoot_loop_end
            fire_alien_shoot_hit_boulder5:
            mov game_matrix[bx], ID_BLANK
            call update_matrix_at_index
            jmp fire_alien_shoot_loop_end
    fire_alien_shoot_loop_end:
        ret
endp fire_alien_shoot

;sleeps for about 30ms
proc delay
    push cx
    mov cx, 003H
    delay_rep: 
    push cx
    mov cx, 7500
    delay_dec: 
    dec cx
    jnz delay_dec
    pop cx
    dec cx
    jnz delay_rep
    pop cx
    ret
endp delay

;sleeps for about 250ms
proc sleep250ms
    push cx
    mov cx, 003H
    sleep250ms_rep: 
    push cx
    mov cx, 65000
    sleep250ms_dec: 
    dec cx
    jnz sleep250ms_dec
    pop cx
    dec cx
    jnz sleep250ms_rep
    pop cx
    ret
endp sleep250ms

;clears the screen
proc clear_screen
    mov ax, 0A000h
    mov es, ax
    xor di, di
    xor ax, ax
    mov cx, 32000d
    cld
    rep stosw
    ret
endp clear_screen

;quit the game
EXIT: 
    mov ax, 3       ;restore the video mode to original
    int 10h         
    mov ah, 4ch     ;end program
    int 21h

END