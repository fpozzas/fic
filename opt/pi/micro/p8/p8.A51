NAME PRAC08
;
; PRACTICA 08. Configuración y transmisión del puerto serie
;
PILA	SEGMENT IDATA
	RSEG PILA
	DS 16
;
	CSEG AT 0
	LJMP INICIO
;
	USING 0
;
INICIO:
	MOV SP,#PILA-1
	; Inicializar puerto serie y timer 1
	MOV TMOD,#20h ; T1 en autorrecarga
	MOV PCON,#80h ; SMOD=1
	MOV TH1,#0F9h ; 8928 baudios SMOD=1 con 12MHz
	SETB TR1
	MOV SCON,#40h
Transmision:
	MOV A,#41h ; 'A' en ASCII -> 10000001 (simetrico)
	MOV SBUF,A
EsperaRI:
	JNB TI,EsperaRI
	CLR TI
	; Espera de 1sg hasta la siguiente transmisión
	; 1 sg de espera -> usamos la rutina de la practica 3
	MOV R3,#8
	MOV R2,#155
	MOV R1,#255
Retardo:
	DJNZ R1,Retardo
	DJNZ R2,Retardo
	DJNZ R3,Retardo
	JMP Transmision
;
END
