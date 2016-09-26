		MOV CX,16		;inicializa contador de dígitos
		MOV AH,1h		;função DOS para entrada pelo teclado
		XOR BX,BX		;zera BX -> terá o resultado
		INT   21h			;entra, caracter está no AL
;while
TOPO:	CMP AL,0Dh		;é CR?
		JE  FIM			;se sim, termina o WHILE
		AND AL,0Fh		;se não, elimina 30h do caracter
					;(poderia ser SUB AL,30h ou SUB AL, 48)
		SHL	BX,1			;abre espaço para o novo dígito
		OR 	BL,AL		;insere o dígito no LSB de BL
		INT 21h			;entra novo caracter
		LOOP  TOPO		;controla o máximo de 16 dígitos
;end_while
FIM:	RET
