		...		;BX já contem número binário
		MOV CH,4	;CH contador de caracteres hexa
		MOV CL,4	;CL contador de delocamentos
		MOV AH,2h	;prepara exibição no monitor
;for 4 vezes do
TOPO:	MOV DL,BH	;captura em DL os oito bits mais significativos de BX
		SHR DL,CL	;resta em DL os 4 bits mais significativos de BX
;if DL , 10
		CMP DL, 0Ah	;testa se é letra ou número
		JAE LETRA
;then
		ADD DL,30h	;é número: soma-se 30h
		JMP PT1
;else
LETRA:	ADD DL,37h	;ao valor soma-se 37h -> ASCII
;end_if
PT1:	INT 21h		;exibe
		ROL BX,CL	;roda BX 4 casas para a direita
		DEC CH
		JNZ TOPO	;faz o FOR 4 vezes
;end_for
		...		;programa continua
