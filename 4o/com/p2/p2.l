%%
((\+|\-)?[0-9]+\.[0-9]+E(\+|\-)?[0-9]+\n) { printf("Es real (parte entera, fraccional y exponencial).\n");}
((\+|\-)?[0-9]+\.[0-9]+\n) { printf("Es real (parte entera y fraccional.\n");}
((\+|\-)?[0-9]+E(\+|\-)?[0-9]+\n) { printf("Es real (parte entera y exponencial).\n");}
((\+|\-)?[0-9]+\n) { printf("Es real (parte entera).\n");}
(.*\n|\n) {printf("No es real.\n");}
%%
main(){
	yylex();
}
