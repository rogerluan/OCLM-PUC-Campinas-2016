TITLE EX11LISTA DE EXERCICIO
.MODEL SMALL
.STACK 100h
.CODE 
EXIBE_DEC PROC 
CMP AX,0
JGE POSITIVO
MOV AH,2
MOV DL,"-"
INT 21h
MEG AX

POSITIVO:

MOV CX,0
MOV DX,0
MOV BX,10
PUSH DX
INC CX
CMP AX,0

JNE INICIO


EXIBE:
JCX2 FIM 
MOV AH,2
POP DX
ADD DL,48
INT 21h
DEC CX
JMP EXIBE 

FIM:

RET 
EXIBE_DEC ENDP
PRINCIPAL PROC 
MOV AX, 358
CALL EXIBE_DEC
MOV AH,4Ch
INT 21h
PRINCIPAL ENDP
END PRINCIPAL