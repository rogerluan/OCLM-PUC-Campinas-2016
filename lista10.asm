TITLE EX10LISTA DE EXERCICIOS
.MODEL SMALL
.STACK 100h
.CODE 
LE_DEC PROC 
MOV AX,0
MOV CL,0
MOV AH,1
INT 21h
CMP AL,"-"
JNE CONTINUA
MOV CL,1

CONTINUA:

CMP AL,"+"
JNE CONTINUAR 
MOV AH,1
INT21h

CONTUNUAR:

SUB AL,48
MOV AH,0
PUSH AX
MOV AX,10
MUL BX
POP DX 
AND DX,AX
MOV BX,DL
MOV AG,1
INT 21h
CMP AL,0Dh
INT CONTUNA2

FIM:

MOV AX,BX
CMP CL,0 

JE FIM2:

NEG AX

FIM2:

RET
LE_DEC ENDP