TITLE EX4
.MODEL SMALL
.STACK 100h
.CODE
MOV AH,1
INT 21h

MOV CX,8
XOR BX,BX

REPETE:
RCR AL,1
JC CONTA
LOOP REPETE
JMP FIM

CONTA:
INC BL
LOOP REPETE

FIM:

ADD BL,48

MOV AH,2
MOV DL,BL
INT 21h

MOV AH,4Ch
INT 21h

END