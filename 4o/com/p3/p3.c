#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define SIZEPILA 1000
/* La gramática implementada es:
E ‐> TV 
V ‐> +TV | lambda
T‐>  FW  
W ‐> *FW | lambda
F ‐> (E) | n
que coincide con la del ejemplo de los apuntes.
*/
/* Desglosamos las reglas:
0) E ‐> TV 
1) V ‐> +TV
2) V -> lambda
3) T‐>  FW  
4) W ‐> *FW
5) W -> lambda
6) F ‐> (E)
7) F -> n
*/
char * reglas[8][2] = {
{"E","TV"},
{"V","+TV"},
{"V","l"},
{"T","FW"},
{"W","*FW"},
{"W","l"},
{"F","(E)"},
{"F","n"}
};

/* La tabla es la misma que la de los apuntes */

int tabla[5][6] ={
{  0, -1, -1,  0, -1, -1 },
{ -1,  1, -1, -1,  2,  2 },
{  3, -1, -1,  3, -1, -1 },
{ -1,  5,  4, -1,  5,  5 },
{  7, -1, -1,  6, -1, -1 }
};

int getcolumna(char c){
	switch(c){
		case 'n': return 0; break;
		case '+': return 1; break;
		case '*': return 2; break;
		case '(': return 3; break;
		case ')': return 4; break;
		case '$': return 5; break;
		default: return -1; // Es un numero
	}
}

int getfila(char c){
	switch(c){
		case 'E': return 0; break;
		case 'V': return 1; break;
		case 'T': return 2; break;
		case 'W': return 3; break;
		case 'F': return 4; break;
		default: return -1;
	}
}

int pp = -1;
char pila[SIZEPILA];
int push(char c){
	pp++;
	pila[pp]=c;
	return 0;
}

int pilavacia(){
	if (pp==-1) return 1;
	else return 0;
}
char pop(){
	if (pilavacia()){
		printf("pop: Pila vacia");
		exit(0);
	}
	char c = pila[pp];
	pp--;
	return c;
}

char head(){
	if (pilavacia()){
		printf("head: Pila vacia");
		exit(0);
	}
	else return pila[pp];
}

int reduccion(char X, char a){
	int f = getfila(X);
	int c = getcolumna(a);
	if (f==-1) {
		printf("Se esperaba: %c\n",X);
		return 0;
	}
	if (c==-1) {
		printf("Caracter inválido: %c\n",a);
		return 0;
	}
	int r = tabla[f][c];
	if (r==-1) {
		printf("Operador no esperado: %c\n",a);
		return 0;
	}
	pop();
	int i;
	char * rder = reglas[r][1];
	if (!strcmp(rder,"l")) return 1;
	for (i=strlen(rder)-1;i>=0;i--) push(rder[i]);
	return 1;
}

int parser(char * entrada){
	int index=0;
	push('$');
	push('E');
	char X = head();
	char a = entrada[index];
	while(1){
		// Si X = a = $ -> exito en el analisis
		if (X=='$'){
			if (X==a) return 0;
			else return 1;
		}
		else if (X==a){
			pop();
			X = head();
			index++;
			a = entrada[index];
		}
		else{
			if (reduccion(X,a)) X = head();
			else return 2;
		}
	}
}

int main(int argc, char *argv[]){
	if (argc != 2){
		printf("Uso: p3 <cadena>\n");
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
	

