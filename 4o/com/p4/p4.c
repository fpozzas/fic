#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define MAYOR 0
#define MENOR 1
#define MASM 2
/* La gramática implementada es:
S ‐> aAa 
A ‐> bB  
A ‐> c  
B ‐> Acd 
que coincide con el ejemplo de los apuntes, por lo que
la correspondiente tabla nos vale para la implementación.
*/
char * reglas[4][2] = {
{"S","aAa"}, 
{"A","bB"}, 
{"A","c"}, 
{"B","Acd"}
};

int getprod(char * pivote){
	int i;
	for (i=0;i<4;i++){
		if (!strcmp(pivote,reglas[i][1])) return i;
	}
	printf("Pivote invalido: %s\n",pivote);
	return -1;
}

int tabla[7][7] ={
{  -1, -1, -1, -1, -1, -1, -1 },
{  -1, -1, MASM , -1, MENOR , MENOR , -1 },
{  -1, MASM , -1, -1, MASM , -1, -1 },
{  -1, MAYOR , -1, -1, MAYOR , -1, -1 },
{  -1, MAYOR , -1, -1, MAYOR , -1, MASM  },
{  -1, -1, MENOR ,  MASM, MENOR , MENOR , -1 },
{  -1, MAYOR , -1, -1, MAYOR , -1, -1 },
};

int getpos(char c){
	switch(c){
		case 'S': return 0; break;
		case 'a': return 1; break;
		case 'A': return 2; break;
		case 'B': return 3; break;
		case 'c': return 4; break;
		case 'b': return 5; break;
		case 'd': return 6; break;
		default: printf("Carácter inválido : %c\n",c); exit(0);
	}
}

int parser(char * entrada){
	char * cadena = (char *) malloc(strlen(entrada)*sizeof(char));
	strcpy(cadena,entrada);
	int menor = 0;
	int mayor = strlen(cadena);
	int simb;
	int i,prod;
	char * pivote;
	char * newcadena;
	while(strlen(cadena)>0){
		if (!strcmp(cadena,"S")) return 0;
		menor = 0;
		mayor = strlen(cadena);
		for (i=1;i<strlen(cadena);i++){
			simb = tabla[getpos(cadena[i-1])][getpos(cadena[i])];
			if (simb == MENOR) menor = i;
			if (simb == MAYOR) {
				mayor = i;
				i=strlen(cadena);
			}
		}
		// Cogemos pivote
		int sizepivote = mayor-menor;
		pivote = (char *) malloc(sizeof(char)*(sizepivote+1));	
		strcpy(pivote, "");
		strncat(pivote, &cadena[menor], sizepivote);
		prod = getprod(pivote);
		if (prod<0) return 1;
		// Insertamos el nuevo pivote en la cadena
		newcadena = (char *) malloc(sizeof(char)*(strlen(cadena)-strlen(pivote)+strlen(reglas[prod][0])));
		strncpy(newcadena,cadena,menor);
		strcat(newcadena,reglas[prod][0]);
		strcat(newcadena,&cadena[mayor]);
		free(cadena);
		free(pivote);
		cadena = newcadena;
	}
	return 1;
}

int main(int argc, char *argv[]){
	switch (parser(argv[1])){
		case 0: printf("ÉXITO: Cadena pertenece al lenguaje\n"); exit(0);
		case 1: printf("Error: Cadena no pertenece al lenguaje\n"); exit(0);
	}
}

