NAME PRAC07
;
; PRACTICA 07. Control de un servomotor
;
PILA	SEGMENT IDATA
	RSEG PILA
	DS 16
;
	CSEG AT 0
	LJMP INICIO
;
	USING 0
ORG 0Bh
JMP ISRservo
INICIO:
	MOV SP,#PILA-1
	; Inicialización del timer
	MOV TMOD,#01h
	MOV TL0,#0F0h
	MOV TH0,#0FFh
	SETB EA
	SETB ET0
	SETB TR0
	SJMP $
;
ISRservo:
	PUSH PSW
	PUSH ACC
	CLR EA
	CLR ET0
	CLR TR0
	USING 1
	; Inicialización del timer para 1,5ms
	; 1,5 ms -> 1500 ciclos
	; FFh - 1500 = 64035 = FA23h
	; Ajustamos con +10 ciclos por retardos de 
	; las instrucciones intermedias -> FA23h + 0Ad = FA2Dh
	MOV TL0,#2Dh
	MOV TH0,#0FAh
	SETB P1.3
	SETB TR0
Bucle1:	JNB TF0,Bucle1
	CLR TF0
	CLR TR0
	; Inicialización del timer para 20ms
	; 20 ms -> 20.000 ciclos
	; FFh - 20000 = 45535 = B1DFh
	; Ajustamos con +10 ciclos por retardos de 
	; las instrucciones intermedias -> B1DFh + 0Ad = FAE9h
	CLR P1.3
	MOV TL0,#0E9h
	MOV TH0,#0B1h
	USING 0
	SETB EA
	SETB ET0
	SETB TR0
	POP ACC
	POP PSW
	RETI
END	