%{
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include "funciones.c"
#include <string.h>

FILE * yyin;
void yyerror(const char *str);
void funcomandos();
int desdeFich;

%}
%union {char *s;}

%token COGER USAR EXIT CON INVENTARIO HABLAR DAR A EXAMINAR OBSERVAR IR COMANDOS EOL
%token <s> WORD WS
%type <s> words
%%
entrada		:	
			|	entrada expr { if (!desdeFich) printf(">> "); else printf("-----\n"); }
			;
			
expr		:	hablar 
			|	coger 
			|	usarcon 
			|	exit 
			|	inventario 
			|	dara 
			|	examinar 
			|	observar 
			|	observarobj
			|	ira 
			|	comandos 
			;

hablar		:	HABLAR WS CON WS words EOL {accionInteractuable(interactuableDisponible($5,HABLAR),HABLAR);}
			;
inventario	:	INVENTARIO EOL { funinventario(); }
			;
			
usarcon		:	USAR WS words WS CON WS words EOL  {accion(objetoInvDisponible($3),interactuableDisponible($7,USAR),USAR);}
			;
			
coger		:	COGER WS words EOL {accionObjeto(objetoSalaDisponible($3),COGER);}
			;
			
exit		:	EXIT EOL	{ printf("Adios!\n"); exit(0); }	
			;
dara		:	DAR WS words WS A WS words EOL {accion(objetoInvDisponible($3),interactuableDisponible($7,DAR),DAR);}
			;
			
examinar	:	EXAMINAR WS words EOL {funexaminar(objetoInvDisponible($3));}
			;
			
observar	:	OBSERVAR EOL {funobservar();}
			;
observarobj :	OBSERVAR WS words EOL {funobservarobj($3);}
			;
ira			:	IR WS A WS words EOL {funira($5);}
			;

comandos	:	COMANDOS EOL	{ funcomandos(); }
			;
words		:	WORD	{$$ = $1;}
			|	words WS WORD 
				{ 
					char * buf = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+1)); 
					strcpy(buf,$1);
					strcat(buf,$2);
					strcat(buf,$3);
					$$ = buf;
				}
			;
%%

void yyerror(const char *str)
{
	printf("No entiendo lo que dices.\n");
}

void funcomandos(){
	printf("Comandos:\n");
	printf("  comandos\n");
	printf("  observar\n");
	printf("  inventario\n");
	printf("  coger X\n");
	printf("  usar X con Y\n");
	printf("  dar X a Y\n");
	printf("  hablar con Y\n");
	printf("  examinar X\n");
	printf("  ir a X\n");
	printf("  exit\n");
}

int main(int argc, char * argv[]){
	printf("Practica final de Compiladores\n");
	printf("Autores:\n - Daniel Fernández Núñez (infdfn01)\n - Luis Yáñez Rodríguez\n\n");
	desdeFich = 0;
	if (argc==2) {
		desdeFich = 1;
		yyin = fopen(argv[1],"r");
		printf("Ejecutando desde fichero: %s\n-----\n",argv[1]);
	}
	init();
	char entrada[100];
	while(1){
		if (!desdeFich) printf(">> ");
		yyparse();
	}
}
