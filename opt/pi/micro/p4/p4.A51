NAME PRAC04
;
; PRACTICA 04. Conversión de datos
;

PILA	SEGMENT IDATA ; Pila a RAM interna
	RSEG PILA ; Activa el segmento
	DS 16 ; Reserva 16 bytes a PILA
;
	CSEG AT 0 ; Segmento absoluto en 0
	LJMP INICIO ; A inicio del programa
;
CODIGO	SEGMENT CODE
	RSEG CODIGO
	USING 0 ; Banco de registros 0

;
; Bucle del programa principal
;
INICIO:
	MOV SP,#PILA-1
;	MOV A,#37 ; Para BCD -> 25d
;	LCALL BcdBin
;	MOV A,#25
;	LCALL BinBcd
;	MOV A,#35h
;	MOV B,#32h
;	LCALL AscBcd
	MOV A,#46h ; En ascii será A=34h, B=36h
	LCALL BcdAsc
	SJMP $

BcdBin:
	MOV B,A
 	; Dejamos en R0 los 4 bits menos significativos
	ANL B,#0Fh
	MOV R0,B
	; Dejamos en A los 4 bits más significativos en los 4 bits menos significativos
	SWAP A
	ANL A,#0Fh
	; Multiplicar por 10 y sumar los bits menos significativos
	MOV B,#10
	MUL AB
	ADD A,R0
	RET
BinBcd:
	MOV R0,A
	; Dividimos entre 10, tenemos el primer cuarteto del BCD
	MOV B,#10
	DIV AB
	; Al binario original le restamos el primer cuarteto * 10
	; Obtenemos el segundo cuarteto
	MOV R1,A
	MOV B,#10
	MUL AB ; Primer cuarteto * 10
	MOV B,A
	MOV A,R0
	SUBB A,B ; Segundo cuarteto = Binario - Primer cuarteto * 10
	; Combinamos ambos cuartetos
	MOV B,A
	MOV A,R1
	SWAP A
	ORL A,B
	RET
AscBcd:
	ANL A,#0Fh
	ANL B,#0Fh
	SWAP A
	ORL A,B
	RET
	; Salida en A
BcdAsc:
	MOV B,A
	SWAP A
	ANL A,#0Fh
	ORL A,#30h
	ANL B,#0Fh
	ORL B,#30h
	RET
	; Salida en A y B
END
