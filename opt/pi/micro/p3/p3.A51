	NAME PRAC03
;
; PRACTICA 03. Instrucciones de control y llamadas a subrutinas
;
;
PILA	SEGMENT IDATA ; Pila a RAM interna
	RSEG PILA ; Activa segmento
	DS 16 ; Reserva 16 bytes a la PILA
;
	CSEG AT 0 ; Segmento absoluto en 0
	LJMP INICIO ; A inicio programa
;
CODIGO	SEGMENT CODE
    	RSEG CODIGO ; Activa segmento de código
	USING 0 ; Banco de registros 0

;
; Bucle del programa principal
;
INICIO:
	MOV SP,#PILA-1; Pone puntero a inicio PILA
	MOV A,#1
	;LCALL MulPorts; Multiplicación de ports
	;LCALL Mulport0; Idem
	LCALL Intermitencia ; Intermitencia de 1 segundo
	SJMP $ ; Bucle de espera
;;;;;;;;;
MulPorts:
	; Salto incondicional a partir de @A+DPTR
	; Multiplicamos por 4 -> dos desplazamientos a la izquierda
	RL A
	RL A
	MOV DPTR,#MULP0
	MOV B,P1
	JMP @A+DPTR
MULP0:
	MOV A,P0
	MUL AB
	RET
MULP1:
	MOV A,P1
	MUL AB
	RET
MULP2:
	MOV A,P2
	MUL AB
	RET
MULP3:
	MOV A,P3
	MUL AB
	RET
;;;;;;;;
Mulport0:
	MOV B,P1
	; Salto condicional segun valor de A
	CJNE A,#0,MULPB0
	MOV A,P0
	MUL AB
	RET
MULPB0:	CJNE A,#1,MULPB1
	MOV A,P1
	MUL AB
	RET
MULPB1:	CJNE A,#1,MULPB2
	MOV A,P2
	MUL AB
	RET
MULPB2:	MOV A,P3
	MUL AB
	RET
;;;;;;;;
Intermitencia:
	; 12MHz -> en realidad es 1MHz
	; DJNZ -> 2 ciclos -> 500000 DJNZs
	JB P1.1,Delay
	RET
Delay:
	MOV R3,#8
	MOV R2,#155
	MOV R1,#255
Retardo:
	DJNZ R1,Retardo
	DJNZ R2,Retardo
	DJNZ R3,Retardo
	RET
END
