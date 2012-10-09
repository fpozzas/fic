#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include "pilas.h"

#define IIRA 6 
#define NESTADOS 12

#define d4 4
#define d5 5
#define d6 6
#define d7 7
#define d11 11
#define r0 12
#define r1 13
#define r2 14
#define r3 15
#define r4 16
#define r5 17
#define r6 18
#define OK 9999
#define v -1
/* La gramática implementada es:
E'‐>E 
E‐>E+T|T 
T‐>T*F|F 
F‐>(E)|id 
que es un ejemplo de los apuntes y que, por lo tanto,
usaremos su tabla para la implementación.
Para simplificar el parsing, vamos a renombrar el terminal
"id" por "n".
*/
/* Desglosamos las reglas:
0) S ‐> E
1) E -> E+T
2) E -> T
3) T -> T*F
4  T -> F
5) F -> (E)
6) F -> n
*/

/* Nomenclatura de lo que guardamos en las tablas
PARA LA TABLA ACCIÓN
d0 -> 0
d1 -> 1
...
d11 -> 11
r0 -> 12 (12 mod 12 = 0)
r1 -> 13 (13 mod 12 = 1)
...
Esto es, si el número X en la tabla es mayor o igual 
que NESTADOS, es una reducción sobre la regla X mod NESTADOS 
PARA LA TABLA IR_A
Guardamos los estados de 0-11 sin "codificar"
*/

char * reglas[7][2] = {
{"S","E"},
{"E","E+T"},
{"E","T"},
{"T","T*F"},
{"T","F"},
{"F","(E)"},
{"F","n"}
};

int getpos(char c){
	if(isdigit(c))
		return (c-'0');
	switch(c){
		case 'n': return 0; break;
		case '+': return 1; break;
		case '*': return 2; break;
		case '(': return 3; break;
		case ')': return 4; break;
		case '$': return 5; break;
		case 'E': return 6; break;
		case 'T': return 7; break;
		case 'F': return 8; break;
		default: printf("Carácter inválido %c\n",c); return -1;
	}
}

int accion[12][6] ={	
	{ d5	, -1	, -1	, d4	, -1	, -1	},
	{ -1	, d6	, -1	, -1	, -1	, OK	},
	{ -1	, r2	, d7	, -1	, r2	, r2	},
	{ -1	, r4	, r4	, -1	, r4	, r4	},
	{ d5	, -1	, -1	, d4	, -1	, -1	},
	{ -1	, r6	, r6	, -1	, r6	, r6	},
	{ d5	, -1	, -1	, d4	, -1	, -1	},
	{ d5	, -1	, -1	, d4	, -1	, -1	},
	{ -1	, d6	, -1	, -1	, d11	, -1	},
	{ -1	, r1	, d7	, -1	, r1	, r1	},
	{ -1	, r3	, r3	, -1	, r3	, r3	},
	{ -1	, r5	, r5	, -1	, r5	, r5	}
};

int ira[12][3] = {	
	{  1,  2,  3},
	{ -1, -1, -1},
	{ -1, -1, -1},
	{ -1, -1, -1},
	{  8,  2,  3},
	{ -1, -1, -1},
	{ -1,  9,  3},
	{ -1, -1, 10},
	{ -1, -1, -1},
	{ -1, -1, -1},
	{ -1, -1, -1},
	{ -1, -1, -1}
};

int getposira(char c){
	switch(c){
		case 'E': return 0; break;
		case 'T': return 1; break;
		case 'F': return 2; break;
		default: printf("Carácter inválido IR_A: %c\n",c); return -1;
	}
}

int desplazar(char c,int estado){
	spush(c);
	epush(estado);
	return 0;
}

int reducir(int r) {
	int i;
	char * rder = reglas[r][1];
	// Reducimos
	for (i=strlen(rder)-1;i>=0;i--){
		if (shead()==rder[i]){
			spop();
			epop();
		}
		else{
			printf("Se esperaba %c pero se encontró %c\n",rder[i],shead());
			return -1;	
		}
	}
	// Insertamos la parte izquierda
	char rizq = (reglas[r][0])[0];
	int posira = getposira(rizq);
	spush(rizq);
	if ( (posira<0) || ((i=ira[ehead()][posira])<0)){
		printf("Error ir_a: no se va a nada con (%i,%c)",ehead(),rizq);
		return -2;
	}
	else epush(i);
	return 0;
}

int parser(char * entrada){
	int index = 0;
	int pos,estado,acc;
	epush(0);
	while(1){
		if ((pos = getpos(entrada[index]))<0) return 1;
		estado = ehead();
		if ((acc = accion[estado][pos])<0){
			printf("No hay acción para el par (%i,%c)\n",estado,entrada[index]);
			printf("No se esperaba el carácter '%c' en la posición %i\n",entrada[index],index+1);
			return 2;
		}
		if (acc==OK) return 0;
		if (acc>=NESTADOS){ // es reduccion?
			reducir(acc%NESTADOS);
		}
		else{ // es desplazamiento?
			desplazar(entrada[index],acc);
			index++;
		}
	}
}

int main(int argc, char *argv[]){
	if (argc != 2){
		printf("Uso: p5 <cadena>\n");
		exit(0);
	}
	// Concatenar un $ al final
	char * entrada = (char *)malloc(strlen(argv[1])+sizeof(char));
	strcpy(entrada,argv[1]);
	strcat(entrada,"$");
	switch (parser(entrada)){
		case 0: printf("ÉXITO: Cadena aceptada\n"); break;
		default: printf("Error: Cadena no aceptada\n");
	}
}
