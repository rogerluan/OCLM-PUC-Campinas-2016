TITLE EX9 - LE_BIN
.MODEL SMALL
.STACK 100h
.CODE

LE_BIN PROC
    MOV CX,16
    INICIO:
        MOV AH,1
        INT 21H
        AND AL,00000001b
        SHL BL,AL
        LOOP INICIO
        MOV AX,BX
        RET
LE_BIN ENDP

MAIN PROC
    CALL LE_BIN
    MOV AH,4CH
    INT 21H
MAIN ENDP
END MAIN