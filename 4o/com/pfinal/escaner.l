%{
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <stdlib.h>
#include "y.tab.h"


// funciones y variables


%}

word [a-zA-Z]+
ws	[" "\t]+

%%

{ws} 					{ yylval.s = strdup(yytext); return WS; }
"coger"					{ return COGER; }
"usar"					{ return USAR; }
"exit"|"quit"|"adios"	{ return EXIT; }
"inventario"			{ return INVENTARIO; }
"hablar"				{ return HABLAR; }
"con"					{ return CON; }
"dar"					{ return DAR; }
"a"						{ return A; }
"examinar"				{ return EXAMINAR; }
"observar"				{ return OBSERVAR; }
"ir"					{ return IR; }
"comandos"|"help"		{ return COMANDOS; }
{word}     				{ yylval.s = strdup(yytext); return WORD; }
\n						{ return EOL; }
.						{ /* printf("(ignorando : %s)\n",yytext); */ }

%%
