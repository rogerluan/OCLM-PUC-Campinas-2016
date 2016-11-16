;;
;; Copyright (C) 2012 by Daniel Rivas <dev.daniel.e.rivas.s@gmail.com> and Nelson Santander <asdruvil@gmail.com>
;;
;;   This program is free software; you can redistribute it and/or modify
;;   it under the terms of the GNU General Public License as published by
;;  the Free Software Foundation; either version 2 of the License, or
;;   (at your option) any later version.
;;   This program is distributed in the hope that it will be useful,
;;   but WITHOUT ANY WARRANTY.
;;
;
;--------------------
;SPACE INVADERS CLONE
;--------------------
;
;
;Controls
;
;Arrow keys: move
;Esc: exit
;
;Shooting
;The ship shoots automatically, so, you don't have to worry about it
;
.model small
.stack 200h
.386
.data

MAX_SHOOTS EQU 20

MAX_ALIENS EQU 55

object struc
	alive dw ?
	pos_x dw ?
	pos_y dw ?
	s_width dw ?
	s_height dw ?
	colour db ?
object ends

rectangle struc
	top dw ?
	right dw ?
	bottom dw ?
	left dw ?
rectangle ends

; general data
mode dw 13h ; vide mode
bg_color dw 16
game_over dw 0
won dw 0

; variables used in collision check
rect rectangle <0, 0, 0, 0>
c_alien dw 0
c_shot dw 0


; hero data
hero object <1, 155, 190, 10, 10,47>
hero_shoots object MAX_SHOOTS dup(<0, 0, 0, 1, 10, 47>)
shoot_count dw 0
shoot_each dw 5

; aliens data
aliens object MAX_ALIENS dup(<1, 0, 0, 10, 10, 15>)
kill_count dw 0
move_count dw 0 ; move count
move_each dw 20 ; update every x cicles
move_dir dw 1 ; 0 left, 1 right

.code
	; GENERAL PROCEDURES
	; checks for collisions between shots and aliens
	check_collisions proc
		mov c_alien, 0 ; loop count for aliens
		loop_collision_alien:
			cmp c_alien, MAX_ALIENS
			jge end_loop_collisioin_alien
			; get alien data
			mov ax, size object
			mul c_alien
			add ax, offset aliens
			mov si, ax
			cmp [si+alive], 0
			je end_loop_collision_shot
			mov ax, [si+pos_y] ; top
			mov bx, [si+pos_x]
			add bx, [si+s_width] ; right
			mov cx, [si+pos_y]
			add cx, [si+s_height] ; bottom
			mov dx, [si+pos_x] ; left
			; saves rectangle
			mov si, offset rect
			mov [si+top], ax
			mov [si+right], bx
			mov [si+bottom], cx
			mov [si+left], dx
			; saves si
			mov di, si
			; begin next loop
			mov c_shot, 0 ; loop count for shoots
			loop_collision_shot:
				cmp c_shot, MAX_SHOOTS
				jge end_loop_collision_shot
				; get bullet data
				mov ax, size object
				mul c_shot
				add ax, offset hero_shoots
				mov si, ax
				cmp [si+alive], 0
				je no_collision
				mov ax, [si+pos_y] ; top
				mov bx, [si+pos_x]
				add bx, [si+s_width] ; right
				mov cx, [si+pos_y]
				add cx, [si+s_height] ; bottom
				mov dx, [si+pos_x] ; left
				; checks for collision
				mov si, di ; restores si1
				cmp [si+top], cx
				jg no_collision
				cmp [si+right], dx
				jl no_collision
				cmp [si+bottom], ax
				jl no_collision
				cmp [si+left], bx
				jg no_collision
				; there's a collision
				; delete alien
				mov ax, size object
				mul c_alien
				add ax, offset aliens
				mov si, ax
				mov [si+alive], 0
				; delete shot
				mov ax, size object
				mul c_shot
				add ax, offset hero_shoots
				mov si, ax
				mov [si+alive], 0
				; increment kill count
				inc kill_count
				cmp kill_count, 55
				jl no_collision
				mov game_over, 1
				mov won, 1
				no_collision:
				inc c_shot
				jmp loop_collision_shot
			end_loop_collision_shot:
			inc c_alien
			jmp loop_collision_alien
		end_loop_collisioin_alien:
		ret
	check_collisions endp

	; HERO PROCEDURES
	; add shot procedure
	add_shot proc
		mov bx, shoot_count
		cmp bx, shoot_each
		jl end_loop_shot
		mov shoot_count, 0 
		mov bx, 0 ; loop count
		loop_shot:
			cmp bx, MAX_SHOOTS
			jge end_loop_shot
			mov ax, size object
			mul bx
			add ax, offset hero_shoots
			mov si, ax
			cmp [si+alive], 0
			je loop_add_shot ; if pointed segment alive is 0, then add shot there
			inc bx
			jmp loop_shot
			loop_add_shot:
				mov [si+alive], 1
				push si
				mov ax, offset hero
				mov si, ax
				mov cx, [si+pos_x]
				mov dx, [si+pos_y]
				pop si
				add cx, 4
				sub dx, [si+s_height]
				mov [si+pos_x], cx
				mov [si+pos_y], dx
		end_loop_shot:
		ret
	add_shot endp
	; draw hero procedure
	draw_hero proc
		mov si, offset hero ; si points to hero address

		; get hero colour
		set_hero_color:
			mov bl, [si+colour]
			cmp game_over, 0
			je end_set_hero_color
			cmp won, 1
			je end_set_hero_color
			mov bl, 40
		end_set_hero_color:
		
		mov ah, 0ch ; draw pixel subfunction
		mov al, bl
	
		mov cx, [si+pos_x]
		mov dx, [si+pos_y]
		
		draw_hero_ship:
			int 10h
			inc cx
			mov bx, [si+pos_x]
			add bx, [si+s_width]
			cmp bx, cx
			jg draw_hero_ship
			mov cx, [si+pos_x]
			inc dx
			mov bx, [si+pos_y]
			add bx, [si+s_height]
			cmp bx, dx
			jg draw_hero_ship
		end_draw_hero_ship:
		
		mov cx, [si+pos_x]
		add cx, 2
		mov dx, [si+pos_y]
		sub dx, 2
		
		draw_hero_ship_top:
			int 10h
			inc cx
			mov bx, [si+pos_x]
			add bx, 8
			cmp bx, cx
			jg draw_hero_ship_top
			mov cx, [si+pos_x]
			add cx, 2
			inc dx
			cmp dx, [si+pos_y]
			jg end_draw_hero_ship_top
			jmp draw_hero_ship_top
		end_draw_hero_ship_top:
		
		ret
	draw_hero endp
	; draw shoots
	draw_shoots proc
		
		mov bx, 0 ; loop count
		loop_draw_shoots:
			cmp bx, MAX_SHOOTS
			jge end_loop_draw_shoots
			mov ax, size object
			mul bx
			add ax, offset hero_shoots
			mov si, ax
			cmp [si+alive], 0
			je next_loop_draw_shoots
			
			mov ah, 0ch ; draw pixel
			mov al, [si+colour]
			mov cx, [si+pos_x]
			mov dx, [si+pos_y]
			
			push bx ; saves bx because we will need it
			draw_shoot:
				int 10h
				inc cx
				mov bx, [si+pos_x] ; bx for comparison
				add bx, [si+s_width]
				cmp bx, cx
				jg draw_shoot
				mov cx, [si+pos_x]
				inc dx
				mov bx, [si+pos_y] ; bx for comparison
				add bx, [si+s_height]
				cmp bx, dx
				jg draw_shoot
			end_draw_shoot:
			pop bx ; restores bx
			
			next_loop_draw_shoots:
				inc bx
				jmp loop_draw_shoots
		end_loop_draw_shoots:
		
		ret
	draw_shoots endp
	; update hero position
	update_hero proc
		mov ah, 01h ; checks if a key is pressed
		int 16h
		jz end_pressed ; zero = no pressed
		
		mov ah, 00h ; get the keystroke
		int 16h
		
		mov si, offset hero ; si points to hero address
		
		; Arrows || Movement
		; Space || Shot
		; Esc || Quit
		begin_pressed:
			cmp ah, 4bh
			je left_pressed
			cmp ah, 4dh
			je right_pressed
			;cmp al, 20h
			;je space_pressed
			cmp al, 1bh
			je quit_pressed
			jmp end_pressed
			left_pressed:
				mov cx, [si+s_width]
				mov bx, [si+pos_x]
				sub bx, cx ; sub for new pos
				cmp bx, 0
				jl end_pressed
				mov [si+pos_x], bx
				jmp end_pressed
			right_pressed:
				mov cx, [si+s_width]
				mov bx, [si+pos_x]
				add bx, cx ; add for new pos
				add bx, cx ; add for right edge of the ship
				cmp bx, 320
				jg end_pressed
				sub bx, cx ; restores pos
				mov [si+pos_x], bx
				jmp end_pressed
			;space_pressed:
				;call add_shot
				;jmp end_pressed
			quit_pressed:
				jmp exit
		end_pressed:
		call add_shot
		inc shoot_count
		
		ret
	update_hero endp
	; updates shoots
	update_shoots proc
		
		mov bx, 0 ; loop count
		loop_update_shoots:
			cmp bx, MAX_SHOOTS
			jge end_loop_update_shoots
			mov ax, size object
			mul bx
			add ax, offset hero_shoots
			mov si, ax
			cmp [si+alive], 0
			je next_loop_update_shoots
			; updates the shoot
			mov dx, [si+s_height]
			sub [si+pos_y], dx ; updates position of shot
			cmp [si+pos_y], 0 ; sees is shoot is out of screen
			jge next_loop_update_shoots
			mov [si+alive], 0 ; deletes shot
			next_loop_update_shoots:
				inc bx
				jmp loop_update_shoots
		end_loop_update_shoots:
		ret
	update_shoots endp

	; ALIEN PROCEDURES
	; initializes the initial position of the aliens
	init_aliens proc
		
		mov bx, 0 ; loop count
		loop_init_aliens:
			cmp bx, MAX_ALIENS
			jge end_loop_init_aliens
			mov ax, size object
			mul bx
			add ax, offset aliens
			mov si, ax
			cmp [si+alive], 0
			je next_loop_init_aliens
			push bx
			; gets the horizonal position of the alien
			mov ax, bx
			mov bx, 11
			div bx ;ax <- ax/bx ; dx <- rest
			mov ax, dx ; dx holds the rest
			mov bx, 20
			mul bx ;ax <- ax*bx
			add ax, 55 ; add the left margin
			mov [si+pos_x], ax
			; gets the vertical position
			pop bx	
			mov ax, bx
			push bx
			mov bx, 11
			div bx
			mov bx, 20
			mul bx
			add ax, 10 ; add the top margin
			mov [si+pos_y], ax
			; restores bx
			pop bx
			next_loop_init_aliens:
				inc bx
				jmp loop_init_aliens
		end_loop_init_aliens:
		ret
	endp
	; draw aliens
	draw_aliens proc

		; draws the force field first
		; 47 green
		; 40 red
		draw_alien_set_color:
			mov bl, 40
			cmp game_over, 0
			je end_draw_alien_set_color
			cmp won, 0
			je end_draw_alien_set_color
			mov bl, 47
		end_draw_alien_set_color:
		mov si, offset aliens
		mov ah, 0ch
		mov al, bl
		mov cx, 0
		mov dx, [si+pos_y]

		loop_draw_force_field_hor:
			int 10h
			add dx, 90 ; heigh of the fleet
			int 10h
			inc cx
			mov dx, [si+pos_y]
			cmp cx, 320
			jl loop_draw_force_field_hor
		end_loop_draw_force_field_hor:

		mov cx, [si+pos_x]
		mov dx, 0

		; gets the bottom limit of the fleet
		mov bx, [si+pos_y]
		add bx, 90

		loop_draw_force_field_ver:
			int 10h
			add cx, 210 ; heigh of the fleet
			int 10h
			inc dx
			mov cx, [si+pos_x]
			cmp dx, bx
			jl loop_draw_force_field_ver
		end_loop_draw_force_field_ver:

		; draw the aliens

		mov bx, 0 ; loop count
		loop_draw_aliens:
			cmp bx, MAX_ALIENS
			jge end_loop_draw_aliens
			mov ax, size object
			mul bx
			add ax, offset aliens
			mov si, ax
			cmp [si+alive], 0
			je next_loop_draw_aliens
			
			push bx ; saves bx because we will need it

			mov ah, 0ch ; draw pixel
			mov al, [si+colour]
			mov cx, [si+pos_x]
			mov dx, [si+pos_y]
			
			draw_alien:
				int 10h
				inc cx
				mov bx, [si+pos_x] ; bx for comparison
				add bx, [si+s_width]
				cmp bx, cx
				jg draw_alien
				mov cx, [si+pos_x]
				inc dx
				mov bx, [si+pos_y] ; bx for comparison
				add bx, [si+s_height]
				cmp bx, dx
				jg draw_alien
			end_draw_alien:
			pop bx ; restores bx
			
			next_loop_draw_aliens:
				inc bx
				jmp loop_draw_aliens
		end_loop_draw_aliens:
		ret
	draw_aliens endp
	; update aliens
	update_aliens proc
		mov bx, move_count
		cmp bx, move_each
		jl end_update_aliens
		mov move_count, 0
		; checks if we need yo change the horizontal position or the vertical position
		mov si, offset aliens

		; check which side to move
		cmp move_dir, 0
		jne check_move_right
		mov ax, [si+pos_x]
		cmp ax, 10
		jg move_left
		mov cx, 0
		mov move_dir, 1
		jmp end_move
		move_left:
		mov ax, [si+s_width]
		mov bx, -1
		mul bx
		mov cx, ax
		jmp end_move

		check_move_right:
		mov ax, size object
		mov bx, 10
		mul bx
		add ax, offset aliens
		mov si, ax
		mov ax, [si+pos_x]
		add ax, [si+s_width]
		cmp ax, 310
		jl move_right
		mov cx, 0
		mov move_dir, 0
		jmp end_move
		move_right:
		mov cx, [si+s_width]
		end_move:
		; end of check which side to move
		; if cx is < 0 move to left
		; if cx is > 0 move to right
		; if cx == 0 move down
		push cx ; saves cx
		mov bx, 0 ; loop count
		loop_update_aliens:
			cmp bx, MAX_ALIENS
			jge end_loop_update_aliens

			mov ax, size object
			mul bx
			add ax, offset aliens
			mov si, ax

			cmp cx, 0
			je move_down
			add [si+pos_x], cx
			jmp next_loop_update_aliens
			move_down:
			mov dx, [si+s_height]
			add [si+pos_y], dx
			next_loop_update_aliens:
			inc bx
			jmp loop_update_aliens
		end_loop_update_aliens:
		pop cx
		cmp cx, 0
		jne end_update_aliens
		cmp move_each, 5
		jle end_update_aliens
		sub move_each, 4
		end_update_aliens:
		check_game_over:
			mov si, offset aliens
			mov bx, [si+pos_y]
			add bx, 90
			cmp bx, 190
			jl end_check_game_over
			mov game_over, 1
			mov won, 0
		end_check_game_over:
		inc move_count
		ret
	update_aliens endp

	; MISC PROCEDURES
	; sets video mode
	set_video proc
		mov ax, mode
		int 10h
		ret
	set_video endp
	; clear screen
	clear_screen proc
		mov ax, 0a000h
		mov es, ax
		xor di, di
		mov ax, bg_color
		mov cx, 64000
		rep stosb
		ret
	clear_screen endp
	; vertical sync
	vsync proc
		mov dx, 3DAh
		wait1_: 
			in al,dx
			test al,8
			jz wait1_
		wait2_:
			in al,dx
			test al,8
			jnz wait2_
		ret
	vsync endp
	
	; main process
	start:
		mov ax, @data
		mov ds, ax

		;--------------------
		;Initializes game
		;--------------------
		call set_video
		call init_aliens
		;--------------------
		;Update game
		;--------------------
		update:
		;call vsync
		call update_hero
		call update_shoots
		call update_aliens
		call check_collisions
		call clear_screen
		call draw_hero
		call draw_shoots
		call draw_aliens
		cmp game_over, 1
		jl update

		;--------------------
		;Game over, wait for keypress
		;--------------------
		loop_game_over:
			mov ah, 00h
			int 16h

			cmp al, 1bh
			je end_loop_game_over
			jmp loop_game_over
		end_loop_game_over:
			
		;--------------------
		;Returns to text mode
		;--------------------
		exit:
			mov ax, 3h
			int 10h
			
			mov ah, 04ch
			mov al, 00
			int 21h
	end start