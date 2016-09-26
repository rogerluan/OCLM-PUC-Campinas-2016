;Calculadora

TITLE CALCULADORA
.MODEL SMALL
.STACK 100h
.DATA
 
MSG   DB "                               CALCULADORA $"
MSG1  DB "Escolha a letra correspondente ao tipo da entrada desejada",10,10, "a)Binaria",10, "b)Decimal" ,10, "c)Hexadecimal $"
MSG2  DB ,10,"              Escolha o tipo da operacao",10,10, "a)AND",10, "b)OR" ,10, "c)XOR" ,10, "d)NOT" ,10, "e)Soma" ,10, "f)Subtracao" ,10, "g)Multiplicacao" ,10, "h)Divisao" ,10, "i)Multiplicacao(varias vezes) por 2" ,10, "j)Divisao(varias vezes) por 2 $"
MSG3  DB ,10,"A opcao selecionada nao existe! Escolha novamente uma opcao valida $"
MSG4  DB ,10,10,"Escolha a letra correspondente a opcao desejada $   "
MSG5  DB "Digite o numero $"
MSG6  DB ,10,10,"Deseja fazer outra operacao? 1-Sim / 2-Nao $"
MSG7  DB "Digite a quantidade de vezes que sera multiplicado por 2 $"
NUM1  DW ?

.CODE
;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;Criando um procedimento para pular linha
PULALINHA PROC
		MOV AH,2
		MOV DL,0AH
		INT 21H
		MOV DL,0DH
		INT 21H
		RET
PULALINHA ENDP
;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENTRA_NUM_DECIMAL PROC
		
		LEA 	DX,MSG5
		MOV 	AH,9H
		INT 	21H
		
		PUSH 	BX
		PUSH 	CX
		PUSH 	DX 			
		XOR 	BX,BX 
		XOR 	CX,CX 
		MOV 	AH,1h
		INT 	21h 		
		CMP 	AL,'-'
		JE 		MENOS
		CMP 	AL,'+' 		
		JE 		MAIS
		JMP 	NUM 		
MENOS: 	MOV 	CX,1 	
MAIS: 	INT 	21h 		
NUM: 	AND 	AX,000Fh 	
		PUSH 	AX 			
		MOV 	AX,10 	
		MUL 	BX 			
		POP 	BX 			
		ADD 	BX,AX 
		MOV 	AH,1h
		INT 	21h 
		CMP 	AL,0Dh 	
		JNE 	NUM 		
		MOV 	AX,BX 		
		CMP 	CX,1 		
		JNE 	SAIDA 		
		NEG 	AX 		
SAIDA: 	POP 	DX
		POP 	CX
		POP 	BX 			
		RET 				
ENTRA_NUM_DECIMAL ENDP
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SAI_NUM_DECIMAL PROC

		MOV 	AX,CX
		
		PUSH 	AX
		PUSH 	BX
		PUSH 	CX
		PUSH 	DX 	
		OR 		AX,AX 
		JGE 	PT1 	
		PUSH 	AX 		
		MOV 	DL,'-'
		MOV 	AH,2h 
		INT 	21h 	
		POP 	AX 		
		NEG 	AX 	
		
PT1: 	XOR 	CX,CX 
		MOV 	BX,10 
PT2: 	XOR 	DX,DX 
		DIV 	BX 	
		PUSH 	DX 
		INC 	CX 		
		OR 		AX,AX 	
		JNE 	PT2 
		
		MOV 	AH,2h 
PT3: 	POP 	DX 		
		ADD 	DL,30h 	
		INT 	21h 	
		LOOP 	PT3 	
		POP 	DX 		
		POP 	CX
		POP 	BX
		POP 	AX 		
		RET 			
SAI_NUM_DECIMAL ENDP
;----------------------------------------------------------------------------------------------------------------------------------------------------------------
ENTRA_NUM_BINARIO PROC

		MOV CX,16		;inicializa contador de dígitos
		MOV AH,1h		;função DOS para entrada pelo teclado
		XOR BX,BX		;zera BX -> terá o resultado
		INT   21h		;entra, caracter está no AL
;while
TOPO:	CMP AL,0Dh		;é CR?
		JE  FIM_BIN		;se sim, termina o WHILE
		AND AL,0Fh		;se não, elimina 30h do caracter
					    ;(poderia ser SUB AL,30h)
		SHL	BX,1		;abre espaço para o novo dígito
		OR 	BL,AL		;insere o dígito no LSB de BL
		INT 21h			;entra novo caracter
		LOOP  TOPO		;controla o máximo de 16 dígitos
;end_while
FIM_BIN:	
	RET

ENTRA_NUM_BINARIO ENDP
;------------------------------------------------------------------------------------------------------------------------------------------------------------------
SAI_NUM_BINARIO PROC

		MOV CX,16		;inicializa contador de bits
		MOV AH,02h		;prepara para exibir no monitor
;for 16 vezes do
POT1:	ROL BX,1		;desloca BX 1 casa à esquerda
;if CF = 1
		JNC  POT2		;salta se CF = 0
;then
		MOV DL, 31h		;como CF = 1
		INT 21h
		JMP P1	;exibe na tela "1" = 31h
;else
POT2:	MOV DL, 30h		;como CF = 0
		INT 21h			;exibe na tela "0" = 30h
;end_if
P1:
		LOOP  POT1		;repete 16 vezes
;end_for
		RET
		
SAI_NUM_BINARIO ENDP
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
ENTRA_NUM_HEXADECIMAL PROC

		XOR BX,BX		;inicializa BX com zero
		MOV CL,4		;inicializa contador com 4
		MOV AH,1h		;prepara entrada pelo teclado
		INT 21h			;entra o primeiro caracter
;while
TOPO_HEX: CMP AL,0Dh	;é o CR ?
		JE  FIM_HEX
		CMP AL, 39h		;caracter número ou letra?
		JG  LETTER		;caracter já está na faixa ASCII
		AND AL,0Fh		;número: retira 30h do ASCII************
		JMP  DESL
LETTER:	SUB AL,37h		;converte letra para binário
DESL:   SHL BX,CL		;desloca BX 4 casas à esquerda
		OR BL,AL		;insere valor nos bits 0 a 3 de BX
		INT 21h			;entra novo caracter
		JMP TOPO_HEX    ;faz o laço até que haja CR
;end_while
FIM_HEX:	RET	


ENTRA_NUM_HEXADECIMAL ENDP
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
SAI_NUM_HEXADECIMAL PROC

;	      ...		;BX já contem número binário
		MOV CH,4	;CH contador de caracteres hexa
		MOV CL,4	;CL contador de delocamentos
		MOV AH,2h	;prepara exibição no monitor
;for 4 vezes do
TOPO_H:	MOV DL,BH	;captura em DL os oito bits mais significativos de BX
		SHR DL,CL	;resta em DL os 4 bits mais significativos de BX
;if DL , 10
		CMP DL, 0Ah	;testa se é letra ou número
		JAE LETRA
;then
		ADD DL,30h	;é número: soma-se 30h
		JMP PTOO1
;else
LETRA:	ADD DL,37h	;ao valor soma-se 37h -> ASCII
;end_if
PTOO1:	INT 21h		;exibe
		ROL BX,CL	;roda BX 4 casas para a direita
		DEC CH
		JNZ TOPO_H	;faz o FOR 4 vezes
;end_for
;		...		;programa continua
		RET
SAI_NUM_HEXADECIMAL ENDP
;------------------------------------------------------------------------------------------------------------------------------------------------------------------
LIMPATELA PROC

		PUSH AX 
		MOV AH,0
		MOV AL, 3
		INT 10h
		POP AX
		RET
		LIMPATELA ENDP
;------------------------------------------------------------------------------------------------------------------------------------------------------------------
;*********************************************************************************************************************************************************************
MAIN PROC

		MOV AX,@DATA
		MOV DS,AX

		CALL LIMPATELA
		CALL PULALINHA

INICIO:
		CALL LIMPATELA
		LEA DX,MSG
		MOV AH,9
		INT 21h

		CALL PULALINHA
		CALL PULALINHA

MENU1:
		LEA DX,MSG1
		MOV AH,9
		INT 21H

		MOV AH,1 
		INT 21h

		CMP AL,'a'
		JE BINARIA

		CMP AL,'b'
		JE PTO_DECIMAL

		CMP AL,'c'
		JE PTO_HEX2
		JMP ERRO1 

ERRO2:
		CALL PULALINHA
		LEA DX,MSG3
		MOV AH,9
		INT 21H
		JMP MENU2
;----------------------------------------------------BINARIO-----------------------------------------------------------------------------------------------
BINARIA:
		CALL LIMPATELA
		LEA DX,MSG2
		MOV AH,9
		INT 21H
		CALL PULALINHA

		LEA DX,MSG4
		MOV AH,9
		INT 21H

		MOV AH,1
		INT 21h
		
		CMP AL, 97 ;verifica se o digito está entre (a - j)
		JB ERRO2

		CMP AL,106 ;verifica se o digito está entre (a - j)
		JA ERRO2

		CMP AL,97
		JE AND_BIN

		CMP AL,98
		JE OR_BIN

		CMP AL,99
		JE XOR_BIN

		CMP AL,100 
		JE NOT_BIN

		CMP AL,101
		JE PULL0

		CMP AL,102
		JE PULL1

		CMP AL,103
		JE PULL2

		CMP AL,104
		JE PULL3

		CMP AL,105
		JE PULL4

		CMP AL,106
		JE PULL5
		
AND_BIN:
		CALL PULALINHA
		CALL ENTRA_NUM_BINARIO
		MOV BX,AX
		
		CALL ENTRA_NUM_BINARIO
		MOV DX,AX
		
		AND BX,DX
		MOV CX,BX
		CALL SAI_NUM_BINARIO
		JMP FINALIZAR_OPERACAO
		
PTO_DECIMAL: JMP DECIMAL
PTO_HEX2   : JMP PTO_HEX


OR_BIN:
		CALL PULALINHA
		CALL ENTRA_NUM_BINARIO
		MOV BX,AX
		
		CALL ENTRA_NUM_BINARIO
		MOV DX,AX
		
		OR BX,DX
		MOV CX,BX
		CALL SAI_NUM_BINARIO
		JMP FINALIZAR_OPERACAO

XOR_BIN:
		CALL PULALINHA
		CALL ENTRA_NUM_BINARIO
		MOV BX,AX
		
		CALL ENTRA_NUM_BINARIO
		MOV DX,AX
		
		XOR BX,DX
		MOV CX,BX
		CALL SAI_NUM_BINARIO
		JMP FINALIZAR_OPERACAO

PULL0: JMP SOMA_BIN		
PULL1: JMP SUB_BIN
PULL2: JMP MUL_BIN
PULL3: JMP DIV_BIN
PULL4: JMP MUL_TWO_BIN
PULL5: JMP DIV_TWO_BIN

NOT_BIN:
		CALL PULALINHA
		CALL ENTRA_NUM_BINARIO
		MOV BX,AX
		
		NOT BX
		MOV CX,BX
		CALL SAI_NUM_BINARIO
		JMP FINALIZAR_OPERACAO

SOMA_BIN:
		CALL PULALINHA
		CALL ENTRA_NUM_BINARIO
		MOV NUM1,BX
		
		CALL ENTRA_NUM_BINARIO
		MOV DX,BX
		
		ADD DX, NUM1
		MOV CX,DX
		CALL SAI_NUM_BINARIO
		JMP FINALIZAR_OPERACAO

SUB_BIN:
		CALL PULALINHA
		CALL ENTRA_NUM_BINARIO
		MOV NUM1,BX
		
		CALL ENTRA_NUM_BINARIO
		MOV DX,BX
		
		SUB DX,NUM1
		MOV BX,DX
		CALL SAI_NUM_BINARIO
		JMP FINALIZAR_OPERACAO

MUL_BIN:
		CALL PULALINHA
		
		CALL ENTRA_NUM_BINARIO
		MOV BX,AX
		
		CALL ENTRA_NUM_BINARIO
		
		MUL BX
		MOV CX,AX
		
		CALL SAI_NUM_BINARIO
		JMP FINALIZAR_OPERACAO
PULO_ERRO2:  JMP ERRO2			

DIV_BIN:
		CALL PULALINHA
		CALL ENTRA_NUM_BINARIO
		MOV NUM1,AX
		
		CALL ENTRA_NUM_BINARIO
		MOV BX,AX
		
		MOV AX,NUM1
		CWD
		DIV BX
		
		MOV CX,AX
		
		CALL SAI_NUM_BINARIO
		JMP FINALIZAR_OPERACAO
		

MUL_TWO_BIN:
		CALL PULALINHA
		CALL ENTRA_NUM_BINARIO
		MOV BX,AX
		PUSH BX
		POP CX
		XOR CH,CH
		XOR BL,BL
		XOR BH,BH
		
		CALL ENTRA_NUM_BINARIO
		MOV DX,AX
		
		SHL DX,CL
		MOV CX,DX
		CALL SAI_NUM_BINARIO
		JMP FINALIZAR_OPERACAO
		
PTO_HEX:  JMP HEXADECIMAL

DIV_TWO_BIN:
		CALL PULALINHA
		CALL ENTRA_NUM_BINARIO
		MOV BX,AX
		PUSH BX
		POP CX
		XOR CH,CH
		XOR BL,BL
		XOR BH,BH
		
		CALL ENTRA_NUM_BINARIO
		MOV DX,AX
		
		SHR DX,CL
		MOV CX,DX
		CALL SAI_NUM_BINARIO
		JMP FINALIZAR_OPERACAO
;---------------------------------------------------------DECIMAL-----------------------------------------------------------------------------------------------
DECIMAL:
		CALL LIMPATELA
		LEA DX,MSG2
		MOV AH,9
		INT 21H
		CALL PULALINHA

		LEA DX,MSG4
		MOV AH,9
		INT 21H

		MOV AH,1
		INT 21h
		
		CMP AL, 97 ;verifica se o digito está entre (a - j)
		JB PULO_ERRO2

		CMP AL,106 ;verifica se o digito está entre (a - j)
		JA PULO_ERRO2

		CMP AL,97
		JE ANDX 

		CMP AL,98
		JE ORX

		CMP AL,99
		JE XORX

		CMP AL,100 
		JE NOTX

		CMP AL,101
		JE PTO_SOMA

		CMP AL,102
		JE PTO_SUB

		CMP AL,103
		JE PTO_MUL

		CMP AL,104
		JE PTO_DIV

		CMP AL,105
		JE PTO_MUL_TWO

		CMP AL,106
		JE DIV_TWO
		
ANDX:
		CALL PULALINHA
		CALL ENTRA_NUM_DECIMAL
		MOV BX,AX
		
		CALL ENTRA_NUM_DECIMAL
		MOV DX,AX
		
		AND BX,DX
		MOV CX,BX
		CALL SAI_NUM_DECIMAL
		JMP FINALIZAR_OPERACAO
		
PTO_SOMA: JMP SOMA

		
PTO_SUB:  JMP SUBTRACAO
		
PTO_MUL:  JMP MULTIPLICACAO
		
PTO_DIV:  JMP DIVISAO
		
PTO_MUL_TWO: JMP MULTIPLICACAO_TWO


DIV_TWO:  JMP DIVISAO_TWO

ORX:
		CALL PULALINHA
		CALL ENTRA_NUM_DECIMAL
		MOV BX,AX
		
		CALL ENTRA_NUM_DECIMAL
		MOV DX,AX
		
		OR BX,DX
		MOV CX,BX
		CALL SAI_NUM_DECIMAL
		JMP FINALIZAR_OPERACAO
XORX:
		CALL PULALINHA
		CALL ENTRA_NUM_DECIMAL
		MOV BX,AX
		
		CALL ENTRA_NUM_DECIMAL
		MOV DX,AX
		
		XOR BX,DX
		MOV CX,BX
		CALL SAI_NUM_DECIMAL
		JMP FINALIZAR_OPERACAO
NOTX:
		CALL PULALINHA
		CALL ENTRA_NUM_DECIMAL
		MOV BX,AX
		
		NOT BX
		MOV CX,BX
		CALL SAI_NUM_DECIMAL
		JMP FINALIZAR_OPERACAO
SOMA:
		CALL PULALINHA
		CALL ENTRA_NUM_DECIMAL
		MOV BX,AX
		
		CALL ENTRA_NUM_DECIMAL
		MOV DX,AX                         
		
		ADD BX,DX
		MOV CX,BX
		CALL SAI_NUM_DECIMAL
		JMP FINALIZAR_OPERACAO
		
PTO1:
		JMP INICIO

SUBTRACAO:
		CALL PULALINHA
		CALL ENTRA_NUM_DECIMAL
		MOV BX,AX
		
		CALL ENTRA_NUM_DECIMAL
		MOV DX,AX
		
		SUB BX,DX
		MOV CX,BX
		CALL SAI_NUM_DECIMAL
		JMP FINALIZAR_OPERACAO
		
MULTIPLICACAO:
		CALL PULALINHA
		CALL ENTRA_NUM_DECIMAL
		MOV BX,AX
		
		CALL ENTRA_NUM_DECIMAL
		
		MUL BX 
		MOV CX,AX
		
		CALL SAI_NUM_DECIMAL
		JMP FINALIZAR_OPERACAO
		
DIVISAO:

		CALL PULALINHA
		CALL ENTRA_NUM_DECIMAL
		MOV NUM1,AX
		
		CALL ENTRA_NUM_DECIMAL
		MOV BX,AX
		
		MOV AX,NUM1
		CWD
		DIV BX
		
		MOV CX,AX
		
		CALL SAI_NUM_DECIMAL
		JMP FINALIZAR_OPERACAO
SALTO1: JMP PULO_ERRO2
		
		
MULTIPLICACAO_TWO:

		CALL PULALINHA
		CALL ENTRA_NUM_DECIMAL
		MOV BX,AX
		PUSH BX
		POP CX
		XOR CH,CH
		XOR BL,BL
		XOR BH,BH
		
		CALL ENTRA_NUM_DECIMAL
		MOV DX,AX
		
		SHL DX,CL
		MOV CX,DX
		CALL SAI_NUM_DECIMAL
		JMP FINALIZAR_OPERACAO		
		
DIVISAO_TWO:
	
		CALL PULALINHA
		CALL ENTRA_NUM_DECIMAL
		MOV BX,AX
		PUSH BX
		POP CX
		XOR CH,CH
		XOR BL,BL
		XOR BH,BH
		
		CALL ENTRA_NUM_DECIMAL
		MOV DX,AX
		
		SHR DX,CL
		MOV CX,DX
		CALL SAI_NUM_DECIMAL
		JMP FINALIZAR_OPERACAO

PONTO1:
		JMP PTO1

;--------------------------------------------------HEXADECIMAL------------------------------------------------------------------------------------------------
HEXADECIMAL:
		CALL LIMPATELA
		LEA DX,MSG2
		MOV AH,9
		INT 21H
		CALL PULALINHA

		LEA DX,MSG4
		MOV AH,9
		INT 21H

		MOV AH,1
		INT 21h
		
		CMP AL, 97 ;verifica se o digito está entre (a - j)
		JB SALTO1

		CMP AL,106 ;verifica se o digito está entre (a - j)
		JA SALTO1

		CMP AL,97
		JE AND_HEX

		CMP AL,98
		JE OR_HEX

		CMP AL,99
		JE XOR_HEX

		CMP AL,100 
		JE NOT_HEX

		CMP AL,101
		JE PUL0

		CMP AL,102
		JE PUL1

		CMP AL,103
		JE PUL2

		CMP AL,104
		JE PUL3

		CMP AL,105
		JE PUL4

		CMP AL,106
		JE PUL5
				
AND_HEX:
		CALL PULALINHA
		CALL ENTRA_NUM_HEXADECIMAL
		MOV NUM1,BX
		
		CALL ENTRA_NUM_HEXADECIMAL
		MOV DX,BX
		
		AND DX, NUM1
		MOV CX,DX
		CALL SAI_NUM_HEXADECIMAL
		JMP FINALIZAR_OPERACAO
		
OR_HEX:
		CALL PULALINHA
		CALL ENTRA_NUM_HEXADECIMAL
		MOV NUM1,BX
		
		CALL ENTRA_NUM_HEXADECIMAL
		MOV DX,BX
		
		OR DX, NUM1
		MOV CX,DX
		CALL SAI_NUM_HEXADECIMAL
		JMP FINALIZAR_OPERACAO
		
XOR_HEX:
		CALL PULALINHA
		CALL ENTRA_NUM_HEXADECIMAL
		MOV NUM1,BX
		
		CALL ENTRA_NUM_HEXADECIMAL
		MOV DX,BX
		
		XOR DX, NUM1
		MOV CX,DX
		CALL SAI_NUM_HEXADECIMAL
		JMP FINALIZAR_OPERACAO

PUL0: JMP SOMA_HEX		
PUL1: JMP SUB_HEX
PUL2: JMP MUL_HEX
PUL3: JMP DIV_HEX
PUL4: JMP MUL_TWO_HEX
PUL5: JMP DIV_TWO_HEX
		
NOT_HEX:
		CALL PULALINHA
		CALL ENTRA_NUM_HEXADECIMAL
		MOV BX,AX
		
		NOT BX
		MOV CX,BX
		CALL SAI_NUM_HEXADECIMAL
		JMP FINALIZAR_OPERACAO
		
SOMA_HEX:
		CALL PULALINHA
		CALL ENTRA_NUM_HEXADECIMAL
		MOV DX,BX
		
		CALL ENTRA_NUM_HEXADECIMAL
		MOV AX,BX
		
		ADD DX,AX
		MOV CX,DX
		CALL SAI_NUM_HEXADECIMAL
		JMP FINALIZAR_OPERACAO
		
SUB_HEX:
		CALL PULALINHA
		CALL ENTRA_NUM_HEXADECIMAL
		MOV NUM1,BX
		
		CALL ENTRA_NUM_HEXADECIMAL
		MOV DX,BX
		
		SUB DX, NUM1
		MOV CX,DX
		CALL SAI_NUM_HEXADECIMAL
		JMP FINALIZAR_OPERACAO
		
MUL_HEX:
		CALL PULALINHA
		CALL ENTRA_NUM_HEXADECIMAL
		MOV BX,AX
		
		CALL ENTRA_NUM_HEXADECIMAL
		
		MUL BX 
		MOV CX,AX
		
		CALL SAI_NUM_HEXADECIMAL
		JMP FINALIZAR_OPERACAO		
		
DIV_HEX:
		CALL PULALINHA
		CALL ENTRA_NUM_HEXADECIMAL
		MOV NUM1,AX
		
		CALL ENTRA_NUM_HEXADECIMAL
		MOV BX,AX
		
		MOV AX,NUM1
		CWD
		DIV BX
		
		MOV CX,AX
		
		CALL SAI_NUM_HEXADECIMAL
		JMP FINALIZAR_OPERACAO
		
MUL_TWO_HEX:
		CALL PULALINHA
		CALL ENTRA_NUM_HEXADECIMAL
		MOV BX,AX
		PUSH BX
		POP CX
		XOR CH,CH
		XOR BL,BL
		XOR BH,BH
		
		CALL ENTRA_NUM_HEXADECIMAL
		MOV DX,AX
		
		SHL DX,CL
		MOV CX,DX
		CALL SAI_NUM_HEXADECIMAL
		JMP FINALIZAR_OPERACAO	
		
DIV_TWO_HEX:
		CALL PULALINHA
		CALL ENTRA_NUM_HEXADECIMAL
		MOV BX,AX
		PUSH BX
		POP CX
		XOR CH,CH
		XOR BL,BL
		XOR BH,BH
		
		CALL ENTRA_NUM_HEXADECIMAL
		MOV DX,AX
		
		SHR DX,CL
		MOV CX,DX
		CALL SAI_NUM_HEXADECIMAL
		JMP FINALIZAR_OPERACAO
		
PULO_PTO1: JMP PONTO1

ERRO3:
		CALL LIMPATELA
		LEA DX,MSG3
		MOV AH,9
		INT 21h
		CALL FINALIZAR_OPERACAO

ERRO1:
		CALL LIMPATELA
		LEA DX, MSG3
		MOV AH,9
		INT 21H
		JMP PTO1

MENU2:
		JMP DECIMAL
		
FINALIZAR_OPERACAO:		
		LEA DX,MSG6
		MOV AH,9
		INT 21h

		MOV AH,1
		INT 21h

		CMP AL,49
		JE PULO_PTO1

		CMP AL,50
		JE FIM
		JMP ERRO3

FIM:
		MOV AH,4CH
		INT 21H

MAIN ENDP
END MAIN