TITLE EX3 - EXIBE MAISCULA
.MODEL SMALL
.STACK 100H
.CODE
MOV AH,1
INT 21H
AND AL,11011111b

MOV AH,4CH
INT 21H
END