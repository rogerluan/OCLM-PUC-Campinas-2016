		MOV CX,16		;inicializa contador de bits
		MOV AH,02h		;prepara para exibir no monitor
;for 16 vezes do
PT1:	ROL BX,1		;desloca BX 1 casa à esquerda
;if CF = 1
		JNC  PT2		;salta se CF = 0
;then
		MOV DL, 31h		;como CF = 1
		INT 21h			;exibe na tela "1" = 31h
;else
PT2:	MOV DL, 30h		;como CF = 0
		INT 21h			;exibe na tela "0" = 30h
;end_if
		LOOP  PT1		;repete 16 vezes
;end_for
