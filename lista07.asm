TITLE EX7LISTA DE EXERCICIOS
.MODE SMALL
.STACK 100h
.CODE 
MOV CX,8
INICIO:
ROL AL,1
RCR BL,1
LOOP INICIO

MOV AH,4Ch 
INT 21h
END