%{
#include "y.tab.h"
%}

%%
[0-9]	{yylval=atoi(yytext); return CIFRA;};
\n		return '\n';
.		return yytext[0];
%%
