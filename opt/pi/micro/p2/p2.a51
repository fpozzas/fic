	NAME PRAC02
;
; PRACTICA 2: Modos de direccionamiento
;

N27 EQU 1BH
MILHEX EQU 1000H
CERO EQU 00H
UNO EQU 01H
DOS EQU 02H
TRES EQU 03H
CUATRO EQU 04H
CINCO EQU 05H
SEIS EQU 06H
SIETE EQU 07H
;
VRESET CODE 0
;
	ORG VRESET	;Pone origen
	USING 0		;Uso del banco de registros 0

;
; Modo de direccionamiento inmediato
;
;
MOD_DIR_INM:
	MOV A,#N27
	MOV DPTR,#MILHEX
	MOV PSW,#CERO
	MOV A,00h ; Dirección de R0 del banco de reginstros 0
	MOV R0,#CERO
	MOV R1,#UNO
	MOV R2,#DOS
	MOV R3,#TRES
	MOV R4,#CUATRO
	MOV R5,#CINCO
	MOV R6,#SEIS
	MOV R7,#SIETE
; Modo de direccionamiento directo
X0 DATA 30H
X1 DATA X0+1
;
MOD_DIR_DIR:
	MOV 30h,#80H
	MOV A,30h ; X0
	MOV 31h,A
	MOV B,90h ; P1
	MOV ACC,#0AH
;
; Modo de direccionamiento registro
;
	USING 2
MOD_DIR_REG:
	MOV PSW,#10H	
	MOV R0,#ACC
;
; Modo de direccionamiento indirecto por registro
;
Y0 XDATA MILHEX
Y1 XDATA Y0+1
;
MOD_DIR_IND_REG:
	MOV R0,#X0
	MOV A,@R0
	MOV DPTR,#Y0
	MOVX @DPTR,A
;
; Modo de direccionamiento indirecto indexado
;
MOD_DIR_INDEX:
	MOV DPTR,#TABLA
	MOV A,#01H ; 00H, 01H, 02H, etc para obtener los caracteres en ASCII
	MOVC A,@A+DPTR ; En A tenemos 32(decimal), el espacio en blanco en ASCII
;
; Modo de direccionamiento orientado a la pila
;
PILA	IDATA	50H
;
MOD_DIR_PIL:
	MOV SP,#PILA-1
	PUSH ACC
	MOV ACC,#00H
	POP ACC   ;
	; POP AR0 ; En la version del lab solo deja mover al acumulador
;
; Modo de direccionamiento orientado a bits
;
XB	BIT	0	; Define simbolo de bit
;
MOD_DIR_BITS:
	MOV C,P1.0 ; C es el bit de acarreo
	MOV XB,C
; Bucle
	SJMP $
;
; Tabla de texto
;
TABLA:	DB	'A CORUÑA'
;
END



