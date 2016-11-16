TITLE EX1
.MODEL SMALL
.STACK 100H
.DATA
VET DB 100 DUP("rogerluan1$")
.CODE
    MOV AX,@DATA
    MOV DS,AX
    MOV CX,10
    MOV BX,0
; INICIO:
;     MOV AH,1
;     INT 21H
;     CMP AL,0DH
;     JE IMPRIME
;     MOV VET[BX],AL
;     INC BX
;     INC CX
;     JMP INICIO
IMPRIME:
    CMP CX,0
    JE FIM
    MOV DL,VET[BX]
    MOV AH,2
    INT 21H
    INC BX
    LOOP IMPRIME
FIM:
    MOV AH,4CH
    INT 21H 
END