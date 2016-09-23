TITLE	proj1
.MODEL	SMALL
.STACK	100h
.DATA
    SYS_READ_CHAR equ 1 
    SYS_PRINT_STR equ 9
    SYS_PRINT_CHAR equ 2
    SYS_INTERRUPT equ INT 21h
    LF EQU 13, 10
    
    PROMPT DB 'Escolha uma opcao:', LF, '$'
    MENU DB '1 - AND', LF, '2 - OR', LF, '3 - XOR', LF, '4 - NOT', LF, '5 - Soma', LF, '6 - Subtracao', LF, '7 - Multiplicacao', LF, '8 - Divisao', LF, '9 - Mult por 2 N vezes', LF, '10 - Div por 2 N vezes', LF, '11 - Sair', LF, 'Opcao: $'

    BASE_CHOICE DB '', LF, 'Qual a base?', LF, '1 - Binario', LF, '2 - Decimal', LF, '3 - Hexadecimal', LF, 'Digite: $'

    FIRST_INPUT DB '', LF, 'Digite um inteiro: $'
    SECOND_INPUT DB '', LF, 'Digite outro inteiro: $'

.CODE

    MOV AX, @DATA           ;get data segment address
    MOV DS, AX              ;initialize ds
    
MAIN:
    MOV     AH, SYS_PRINT_STR
    LEA     DX, PROMPT
    SYS_INTERRUPT

    LEA     DX, MENU
    SYS_INTERRUPT

    MOV     AH, SYS_READ_CHAR
    SYS_INTERRUPT
    
    CMP     AL, 1
    JE      FUNCTION_AND
    CMP     AL, 2
    JE      FUNCTION_OR
    CMP     AL, 3
    JE      FUNCTION_XOR
    CMP     AL, 4
    JE      FUNCTION_NOT
    CMP     AL, 5
    JE      FUNCTION_SUM
    CMP     AL, 6
    JE      FUNCTION_SUB
    CMP     AL, 7
    JE      FUNCTION_MULT
    CMP     AL, 8
    JE      FUNCTION_DIV
    CMP     AL, 9
    JE      FUNCTION_MULT_2X
    CMP     AL, 10
    JE      FUNCTION_DIV_2X
    CMP     AL, 11
    JE      SEMI_EXIT
    
    JMP     MAIN
    
    
FUNCTION_AND:
    
    CALL    INPUT_VALUES
    AND     BX, AX
    
    ;as chamadas devem ler o valor de BX apenas
    CMP     DL, 1
    CALL    OUTPUT_BINARY
    CMP     DL, 2
    CALL    OUTPUT_DECIMAL
    CMP     DL, 3
    CALL    OUTPUT_HEXA
    
    JMP MAIN
    
FUNCTION_OR:

FUNCTION_XOR:

FUNCTION_NOT:

FUNCTION_SUM:

FUNCTION_SUB:

FUNCTION_MULT:

FUNCTION_DIV:

FUNCTION_MULT_2X:

FUNCTION_DIV_2X:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; HELPER PROCEDURES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PROC READ_CHAR ;o char lido vai estar em AL
    MOV     AH, SYS_READ_CHAR
    SYS_INTERRUPT
    RET     ;chamada para retornar do ponto onde foi chamado
ENDP

PROC INPUT_VALUES
    MOV     AH, SYS_PRINT_STR
    LEA     DX, BASE_CHOICE
    SYS_INTERRUPT
    
    ;CALL    READ_CHAR
    MOV     AH, SYS_READ_CHAR
    SYS_INTERRUPT
    
    ;mostra a mensagem para o usuario inserir o primeiro operando
    MOV     AH, SYS_PRINT_STR
    LEA     DX, FIRST_INPUT
    XOR     DX, DX ;zera DX
    MOV     DL, AL ;armazena o conteudo de AL em DL para ser utilizado futuramente
    
    CMP     DL, 1
    CALL    INPUT_BINARY
    CMP     DL, 2
    CALL    INPUT_DECIMAL
    CMP     DL, 3
    CALL    INPUT_HEXA
    
    ;move o operando de BX para AX, para liberar o BX para ser utilizado novamente abaixo
    MOV     AX, BX
    
    ;mostra a mensagem para o usuario inserir o segundo operando
    MOV     AH, SYS_PRINT_STR
    LEA     DX, SECOND_INPUT
    
    CMP     DL, 1
    CALL    INPUT_BINARY
    CMP     DL, 2
    CALL    INPUT_DECIMAL
    CMP     DL, 3
    CALL    INPUT_HEXA
    
    ;agora ha um operando em AX, e outro em BX.

    RET
ENDP

SEMI_EXIT:
    JMP EXIT

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; INPUT PROCEDURES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PROC INPUT_BINARY ;o binario fica armazenado em BX

    MOV     CX, 16		;inicializa contador de dígitos
    MOV     AH, 1		;função DOS para entrada pelo teclado
    XOR     BX, BX		;zera BX -> terá o resultado
    SYS_INTERRUPT		;entra, caracter está no AL
    INPUT_BINARY_WHILE:	
        CMP     AL, 13		;é CR?
        JE      INPUT_BINARY_END			;se sim, termina o WHILE
        SUB     AL, 48      ;se não, elimina 30h == 48 do caracter
        SHL	    BX, 1   	;abre espaço para o novo dígito
        OR      BL, AL  	;insere o dígito no LSB de BL
                            ;entra novo caracter
    LOOP INPUT_BINARY_WHILE	;controla o máximo de 16 dígitos
    INPUT_BINARY_END:
        RET
ENDP

PROC INPUT_DECIMAL

ENDP

PROC INPUT_HEXA 
    XOR     BX, BX		;inicializa BX com zero
    MOV     CL, 4		;inicializa contador com 4
    CALL    READ_CHAR
    INPUT_HEXA_WHILE:	
        CMP    AL, 13		;é o CR ?
        JE     INPUT_HEXA_END
        CMP    AL, 39h		;caracter número ou letra?
        JG     INPUT_HEXA_LETTER		;caracter já está na faixa ASCII
        AND    AL, 0Fh		;número: retira 30h do ASCII
        JMP    INPUT_HEXA_SHIFT
    INPUT_HEXA_LETTER:	
        SUB    AL, 37h		;converte letra para binário
    INPUT_HEXA_SHIFT:
        SHL    BX, CL		;desloca BX 4 casas à esquerda
        OR     BL, AL		;insere valor nos bits 0 a 3 de BX
        SYS_INTERRUPT		;entra novo caracter
        JMP    INPUT_HEXA_WHILE		;faz o laço até que haja CR
    INPUT_HEXA_END:
        RET	
ENDP
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; OUTPUT PROCEDURES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PROC OUTPUT_BINARY
    MOV     CX, 16		;inicializa contador de bits
    MOV     AH, SYS_PRINT_CHAR		;prepara para exibir no monitor
    OUTPUT_BINARY_LOOP:
        ROL     BX, 1		;desloca BX uma casa à esquerda
        ;if CF = 0
        JNC     PT2 		;salta se CF = 0
        ;else
        MOV     DL, 49		;como CF = 1
        SYS_INTERRUPT 		;exibe na tela "1" = 31h = 49
    PT2:	
        MOV     DL, 48		;como CF = 0
        SYS_INTERRUPT		;exibe na tela "0" = 30h = 48
        ;end_if
        LOOP  OUTPUT_BINARY_LOOP		;repete 16 vezes
;end_for
ENDP

PROC OUTPUT_DECIMAL

ENDP

PROC OUTPUT_HEXA
		;BX já contem número binário
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
        SYS_INTERRUPT	    ;exibe
        ROL    BX, CL   ;roda BX 4 casas para a direita
        DEC    CH       ;decrementa o contador
        JNZ    OUTPUT_HEXA_LOOP	    ;volta para o topo caso o contador nao seja zero
ENDP



EXIT:
    MOV AH, 4CH ;exit program
    SYS_INTERRUPT

END