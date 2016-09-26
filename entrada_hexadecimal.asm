
		XOR BX,BX		;inicializa BX com zero
		MOV CL,4		;inicializa contador com 4
		MOV AH,1h		;prepara entrada pelo teclado
		INT 21h			;entra o primeiro caracter
;while
TOPO:	CMP AL,0Dh		;é o CR ?
		JE  FIM
		CMP AL, 39h		;caracter número ou letra?
		JG  LETRA		;caracter já está na faixa ASCII
		AND AL,OFh		;número: retira 30h do ASCII
		JMP  DESL
LETRA:	SUB AL,37h		;converte letra para binário
DESL:   SHL BX,CL		;desloca BX 4 casas à esquerda
		OR BL,AL		;insere valor nos bits 0 a 3 de BX
		INT 21h			;entra novo caracter
		JMP TOPO		;faz o laço até que haja CR
;end_while
FIM:	RET	
