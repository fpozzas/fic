%{
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
%}

%token CIFRA

%%
linea	:	
		|	linea expr '\n'	{ printf("Resultado: %i\n",$2); }
		;
expr	:	expr '+' termino	{ $$ = $1 + $3; }
		|	termino
		;
termino	:	termino '*' factor	{ $$ = $1 * $3; }
		|	factor
		;
factor	:	'(' expr ')'		{ $$ = $2; }
		|	numero
		;
numero	:	numero CIFRA		{ $$ = $1*10 + $2; } 
		|	CIFRA
		;
%%

				/*
yylex() {
	int c;
	c = getchar();
	if (isdigit(c)){
		yylval = c-'0';
		//printf("DIGITO = %i\n",yylval);
		return CIFRA;
	}
	//printf("OP = %c\n",c);
	return c;
}
				*/