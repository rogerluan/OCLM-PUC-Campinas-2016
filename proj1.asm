TITLE	proj1
.MODEL	SMALL
.STACK	100h
.DATA
    SYS_READ_CHAR equ 1 
    SYS_PRINT_STR equ 9
    SYS_PRINT_CHAR equ 2
    
    PROMPT DB 'Escolha uma opcao:', 10, '$'
    MENU DB 'a - AND', 10, 'b - OR', 10, 'c - XOR', 10, 'd - NOT', 10, 'e - Soma', 10, 'f - Subtracao', 10, 'g - Multiplicacao', 10, 'h - Divisao', 10, 'i - Mult por 2 N vezes', 10, 'j - Div por 2 N vezes', 10, 'k - Sair', 10, 'Opcao: $'

    BASE_CHOICE DB '', 10, 'Qual a base?', 10, 'a - Binario', 10, 'b - Decimal', 10, 'c - Hexadecimal', 10, 'Digite: $'

    FIRST_INPUT DB '', 10, 'Digite o operando na base escolhida: $'
    ;SECOND_INPUT DB '', 10, 'Digite o segundo operando na base escolhida: $'
    
    NUM1 DW ?
    OPERATOR DW ?

.CODE

    MOV AX, @DATA           ;get data segment address
    MOV DS, AX              ;initialize ds
    
MAIN:
    CALL CLEAR_SCREEN
    MOV     AH, SYS_PRINT_STR
    LEA     DX, PROMPT
    INT     21h

    LEA     DX, MENU
    INT     21h

    MOV     AH, SYS_READ_CHAR
    INT     21h
    
    CMP     AL, 'a'
    JE      FUNCTION_AND
    CMP     AL, 'b'
    JE      FUNCTION_OR
    CMP     AL, 'c'
    JE      FUNCTION_XOR
    CMP     AL, 'd'
    JE      FUNCTION_NOT
    CMP     AL, 'e'
    JE      FUNCTION_SUM_JUMP
    CMP     AL, 'f'
    JE      FUNCTION_SUB_JUMP
    CMP     AL, 'g'
    JE      FUNCTION_MULT_JUMP
    CMP     AL, 'h'
    JE      FUNCTION_DIV_JUMP
    CMP     AL, 'i'
    JE      FUNCTION_MULT_2X_JUMP
    CMP     AL, 'j'
    JE      FUNCTION_DIV_2X_JUMP
    CMP     AL, 'k'
    JE      EXIT_JUMP
    JMP     MAIN
    
FUNCTION_AND:
    CALL    INPUT_BASE
    CALL    INPUT_VALUES
    MOV     NUM1, BX ;NUM1 recebe BX, para liberar o registrador
    CALL    INPUT_VALUES
    AND     BX, NUM1
    CALL    OPERATOR_OUTPUT_SWITCH
    CALL    READ_CHAR
    JMP     MAIN
    
FUNCTION_OR:
    CALL    INPUT_BASE 
    CALL    INPUT_VALUES
    MOV     NUM1, BX
    CALL    INPUT_VALUES
    OR      BX, NUM1
    CALL    OPERATOR_OUTPUT_SWITCH
    CALL    READ_CHAR
    JMP     MAIN

FUNCTION_XOR:
    CALL    INPUT_BASE
    CALL    INPUT_VALUES
    MOV     NUM1, BX
    CALL    INPUT_VALUES
    XOR     BX, NUM1
    CALL    OPERATOR_OUTPUT_SWITCH
    CALL    READ_CHAR
    JMP     MAIN

FUNCTION_NOT:
    CALL    INPUT_BASE 
    CALL    INPUT_VALUES
    NOT     BX
    CALL    OPERATOR_OUTPUT_SWITCH
    CALL    READ_CHAR
    JMP     MAIN

FUNCTION_SUM_JUMP: JMP FUNCTION_SUM
FUNCTION_SUB_JUMP: JMP FUNCTION_SUB
FUNCTION_MULT_JUMP: JMP FUNCTION_MULT
FUNCTION_DIV_JUMP: JMP FUNCTION_DIV
FUNCTION_MULT_2X_JUMP: JMP FUNCTION_MULT_2X
FUNCTION_DIV_2X_JUMP: JMP FUNCTION_DIV_2X
EXIT_JUMP: JMP EXIT

FUNCTION_SUM:
    CALL    INPUT_BASE 
    CALL    INPUT_VALUES
    MOV     NUM1, BX
    CALL    INPUT_VALUES
    ADD     BX, NUM1
    CALL    OPERATOR_OUTPUT_SWITCH
    CALL    READ_CHAR
    JMP     MAIN

FUNCTION_SUB:
    CALL    INPUT_BASE 
    CALL    INPUT_VALUES
    MOV     NUM1, BX
    CALL    INPUT_VALUES
    SUB     NUM1, BX
    MOV     BX, NUM1
    CALL    OPERATOR_OUTPUT_SWITCH
    CALL    READ_CHAR
    JMP     MAIN

FUNCTION_MULT:
    CALL    INPUT_BASE 
    CALL    INPUT_VALUES
    MOV     NUM1, BX
    CALL    INPUT_VALUES
    MOV     AX, NUM1
    MUL     BX
    MOV     BX, AX
    CALL    OPERATOR_OUTPUT_SWITCH
    CALL    READ_CHAR
    JMP     MAIN

FUNCTION_DIV:
    CALL    INPUT_BASE 
    CALL    INPUT_VALUES
    MOV     NUM1, BX
    CALL    INPUT_VALUES
    MOV     AX, NUM1
    CWD
    DIV     BX
    MOV     BX, AX
    CALL    OPERATOR_OUTPUT_SWITCH
    CALL    READ_CHAR
    JMP     MAIN

FUNCTION_MULT_2X:
    CALL    INPUT_BASE 
    CALL    INPUT_VALUES
    MOV     NUM1, BX
    CALL    INPUT_VALUES
    MOV     CX, NUM1
    XOR     CH, CH ;zera a parte alta pra poder usar o CL abaixo
 
    MOV     DX, BX
    SHL     DX, CL
    MOV     BX, DX
    CALL    OPERATOR_OUTPUT_SWITCH
    CALL    READ_CHAR
    JMP     MAIN

FUNCTION_DIV_2X:
    CALL    INPUT_BASE 
    CALL    INPUT_VALUES
    MOV     NUM1, BX
    CALL    INPUT_VALUES
    MOV     CX, BX
    XOR     CH, CH ;zera a parte alta pra poder usar o CL abaixo

    MOV     DX, NUM1
    SHR     DX, CL
    MOV     BX, DX
    CALL    OPERATOR_OUTPUT_SWITCH
    CALL    READ_CHAR
    JMP     MAIN

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; HELPER PROCEDURES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PROC OPERATOR_INPUT_SWITCH
    CMP     OPERATOR, 'a'
    JE      INPUT_BINARY_JUMP
    CMP     OPERATOR, 'b'
    JE      INPUT_DECIMAL_JUMP
    CMP     OPERATOR, 'c'
    JE      INPUT_HEXA_JUMP

    JMP     INPUT_BASE
ENDP

PROC OPERATOR_OUTPUT_SWITCH
    CMP     OPERATOR, 'a'
    JE      OUTPUT_BINARY_JUMP
    CMP     OPERATOR, 'b'
    JE      OUTPUT_DECIMAL_JUMP
    CMP     OPERATOR, 'c'
    JE      OUTPUT_HEXA_JUMP
    RET
ENDP

PROC READ_CHAR ;o char lido vai estar em AL
    MOV     AH, SYS_READ_CHAR
    INT     21h
    RET
ENDP

PROC  INPUT_BASE
    CALL    CLEAR_SCREEN
    MOV     AH, SYS_PRINT_STR
    LEA     DX, BASE_CHOICE
    INT     21h

    CALL    READ_CHAR

    CBW
    MOV     OPERATOR, AX

    RET
ENDP

PROC INPUT_VALUES
    ;CALL    CLEAR_SCREEN
    
    ;mostra a mensagem para o usuario inserir o operando
    MOV     AH, SYS_PRINT_STR
    LEA     DX, FIRST_INPUT
    INT     21h
    
    CALL    OPERATOR_INPUT_SWITCH
    
    RET ;return in BX.
ENDP

PROC CLEAR_SCREEN
    PUSH AX 
    MOV AH, 0
    MOV AL, 3
    INT 10h
    POP AX
    RET
ENDP

INPUT_BINARY_JUMP: JMP INPUT_BINARY
INPUT_DECIMAL_JUMP: JMP INPUT_DECIMAL
INPUT_HEXA_JUMP: JMP INPUT_HEXA
OUTPUT_BINARY_JUMP: JMP OUTPUT_BINARY
OUTPUT_DECIMAL_JUMP: JMP OUTPUT_DECIMAL
OUTPUT_HEXA_JUMP: JMP OUTPUT_HEXA


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; INPUT PROCEDURES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PROC INPUT_BINARY ;o numero fica armazenado em BX

    MOV     CX, 16		;inicializa contador de dígitos
    XOR     BX, BX		;zera BX -> terá o resultado
    MOV     AH, SYS_READ_CHAR		;função DOS para entrada pelo teclado
    INT     21h		;entra, caracter está no AL
    INPUT_BINARY_WHILE:	
        CMP     AL, 13		;é CR?
        JE      INPUT_BINARY_END			;se sim, termina o WHILE
        SUB     AL, 48      ;se não, elimina 30h == 48 do caracter
        SHL	    BX, 1   	;abre espaço para o novo dígito
        OR      BL, AL  	;insere o dígito no LSB de BL
        INT     21h       ;entra novo caracter
    LOOP INPUT_BINARY_WHILE	;controla o máximo de 16 dígitos
    INPUT_BINARY_END:
        RET
ENDP

PROC INPUT_DECIMAL ;o numero fica armazenado em BX
    PUSH    BX
    PUSH 	CX
    PUSH 	DX
    XOR 	BX, BX
    XOR 	CX, CX
    CALL    READ_CHAR
    CMP 	AL, '-'
    JE 		INPUT_DECIMAL_NEGATIVE
    CMP 	AL, '+'
    JE 		INPUT_DECIMAL_POSITIVE
    JMP 	INPUT_DECIMAL_NUM
INPUT_DECIMAL_NEGATIVE:
    MOV 	CX, 1
INPUT_DECIMAL_POSITIVE:
    INT     21h
INPUT_DECIMAL_NUM:
    AND 	AX, 000Fh
    PUSH 	AX	
    MOV 	AX, 10 	
    MUL 	BX 			
    POP 	BX 			
    ADD 	BX, AX 
    CALL    READ_CHAR
    CMP 	AL, 13
    JNE 	INPUT_DECIMAL_NUM 		
    MOV 	AX, BX 		
    CMP 	CX, 1 		
    JNE 	INPUT_DECIMAL_EXIT 		
    NEG 	AX 		
INPUT_DECIMAL_EXIT:
    POP 	DX
    POP 	CX	
    POP     BX
    MOV     BX, AX
    RET
ENDP

PROC INPUT_HEXA ;o numero fica armazenado em BX
    XOR     BX, BX		;inicializa BX com zero
    MOV     CL, 4		;inicializa contador com 4
    CALL    READ_CHAR
    INPUT_HEXA_WHILE:	
        CMP     AL, 13		;é o CR ?
        JE      INPUT_HEXA_END
        CMP     AL, 39h		;caracter número ou letra?
        JG      INPUT_HEXA_LETTER		;caracter já está na faixa ASCII
        AND     AL, 0Fh		;número: retira 30h do ASCII
        JMP     INPUT_HEXA_SHIFT
    INPUT_HEXA_LETTER:	
        SUB     AL, 37h		;converte letra para binário
    INPUT_HEXA_SHIFT:
        SHL     BX, CL		;desloca BX 4 casas à esquerda
        OR      BL, AL		;insere valor nos bits 0 a 3 de BX
        INT     21h		;entra novo caracter
        JMP     INPUT_HEXA_WHILE		;faz o laço até que haja CR
    INPUT_HEXA_END:
        RET	
ENDP
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; OUTPUT PROCEDURES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PROC OUTPUT_BINARY ;le o numero de BX
    MOV     CX, 16		;inicializa contador de bits
    MOV     AH, SYS_PRINT_CHAR		;prepara para exibir no monitor
    OUTPUT_BINARY_LOOP:
        ROL     BX, 1	;desloca BX uma casa à esquerda
        JNC     PT2 	;jump if CF = 0
        ;else
        MOV     DL, 49	;como CF = 1
        INT     21h 	;exibe na tela "1" = 31h = 49
        JMP     P1
    PT2:	
        MOV     DL, 48	;como CF = 0
        INT     21h		;exibe na tela "0" = 30h = 48
        ;end_if
    P1:
        LOOP  OUTPUT_BINARY_LOOP		;repete 16 vezes
;end_for
ENDP

PROC OUTPUT_DECIMAL ;le o numero de BX
    MOV     AX, BX
    PUSH    AX
    PUSH    BX
    PUSH    CX
    PUSH    DX
    OR      AX, AX
    JGE     OUTPUT_DECIMAL_PT1
    PUSH    AX
    MOV     DL, '-'
    MOV     AH, 2h
    INT     21h
    POP     AX
    NEG     AX
OUTPUT_DECIMAL_PT1:
    XOR     CX, CX
    MOV     BX, 10
OUTPUT_DECIMAL_PT2:
    XOR     DX, DX
    DIV     BX
    PUSH    DX
    INC     CX
    OR      AX, AX
    JNE     OUTPUT_DECIMAL_PT2
    MOV     AH, 2h
OUTPUT_DECIMAL_PT3:
    POP     DX
    ADD     DL, 30h
    INT     21h
    LOOP    OUTPUT_DECIMAL_PT3
    POP     DX
    POP     CX
    POP     BX
    POP     AX
    RET
ENDP

PROC OUTPUT_HEXA ;le o numero de BX
    MOV    CH, 4	;CH contador de caracteres hexa
    MOV    CL, 4	;CL contador de deslocamentos
    MOV    AH, SYS_PRINT_CHAR	;prepara exibição no monitor
    OUTPUT_HEXA_LOOP:
        MOV     DL, BH	;captura em DL os oito bits mais significativos de BX
        SHR     DL, CL	;resta em DL os 4 bits mais significativos de BX

        ;if letra ou numero
        CMP     DL, 10
        JAE     OUTPUT_HEXA_LETTER   ;se for letra, jump

        ;else, soma 48
        ADD     DL, 48
        JMP     OUTPUT_HEXA_PRINT

    OUTPUT_HEXA_LETTER:	
        ADD     DL, 55	;ao valor soma-se 55 -> ASCII
        ;end if

    OUTPUT_HEXA_PRINT:
        INT     21h	    ;exibe
        ROL     BX, CL   ;roda BX 4 casas para a direita
        DEC     CH       ;decrementa o contador
        JNZ     OUTPUT_HEXA_LOOP	    ;volta para o topo caso o contador nao seja zero
    RET
ENDP

EXIT:
    MOV     AH, 4CH ;exit program
    INT     21h

END