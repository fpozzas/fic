NAME PRAC06
;
; PRACTICA 06. Generador de señal
;
PILA	SEGMENT IDATA
	RSEG PILA
	DS 16
;
	CSEG AT 0
	LJMP INICIO
;
	USING 0
INICIO:
	; Poner timer en modo 1
	MOV TMOD,#01h
	SETB P1.7
	LCALL Delay
	CLR P1.7
	LCALL Delay
	LJMP INICIO
Delay:
	MOV TL0,#0Ch
	MOV TH0,#0FEh
	SETB TR0
Bucle:
	JNB TF0,Bucle
	CLR TR0
	CLR TF0
	RET
END	
