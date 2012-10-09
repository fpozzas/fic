#include <stdlib.h>
#include <stdio.h>
#include <string.h>
	
#define DIGITO 1
#define PUNTO 2
#define EXP 3
#define SIGNO 4
#define DOLLAR 5

#define NUM 0
#define SIGNO_NUM 1
#define RESTO_NUM 2
#define FRACCION 3
#define RESTO_FRA 4
#define EXPONENTE 5
#define INT_EXP 6
#define RESTO_INT_EXP 7
#define FIN 8

int M(int i, int j, int valor[],int columna[], int prefil[], int numfil[]){
	int m,num,com,hallado,k;
	num = numfil[i];
	if (num==0) return 9999;
	else{
		com = prefil[i];
		hallado = 0;
		k = 0;
		while((k<num+1) && (!hallado)){
			if (columna[com+k]==j){
				hallado = 1;
			}
			else k++;
			if (hallado) return valor[com+k];
		}
		return 9999;
	}
	return m;
}

int main(int argc, char * argv[]){
	int valor[] = { 2, 1, 2, 2, 3, 5, 8, 4, 4, 5, 8, 7, 6, 7, 7, 8 };
	int columna[] = { 1, 4, 1, 1, 2, 3, 5, 1, 1, 3, 5, 1, 4, 1, 1, 5 };
	int prefil[] = { 0, 2, 3, 7, 8, 11, 13, 14 };
	int numfil[] = { 2, 1, 4, 1, 3, 2, 1, 1 };
	
	
	int st_actual = 0;
	int st_nuevo;
	if (argc!=2) {
		printf("Uso: p1 <numreal>\n");
		return -1;
	}
	char * entrada = argv[1];
	char * p_entera = "";
	char * p_fraccion = ""; 
	char * p_exp = "";
	char * str = "";
	int simbolo;
	int n=0;
	int queda_cadena=1;
	while(queda_cadena){
		if (strlen(entrada)==0) {
			simbolo = DOLLAR;
			queda_cadena = 0;
		}
		else if (entrada[0]=='.') simbolo = PUNTO;
		else if (entrada[0]=='E') simbolo = EXP;
		else if ((entrada[0]=='+') || (entrada[0]=='-')) simbolo = SIGNO;
		else if (isdigit(entrada[0])) simbolo = DIGITO;
		else {
			printf("No es un número real. 1\n");
			return 0;
		}
		st_nuevo = M(st_actual,simbolo,valor,columna,prefil,numfil);
		if (st_nuevo==st_actual) n++;
		else switch(st_nuevo){
			case SIGNO_NUM: n++; break;
			case RESTO_NUM: n++; break;
			case FRACCION:
				p_entera = (char *)malloc(sizeof(char)*n);
				strncpy(p_entera,&entrada[-n],n);
				n=0;
				break;
			case RESTO_FRA: n++; break;
			case EXPONENTE:
				str = (char *)malloc(sizeof(char)*n);
				strncpy(str,&entrada[-n],n);
				if (st_actual==RESTO_NUM) p_entera = str;
				else p_fraccion = str;
				n=0;
				break;
			case INT_EXP: n++; break;
			case RESTO_INT_EXP: n++; break;
			case FIN:
				str = (char *)malloc(sizeof(char)*n);
				strncpy(str,&entrada[-n],n);
				if (st_actual==RESTO_NUM) p_entera = str;
				else if (st_actual==RESTO_FRA) p_fraccion = str;
				else  p_exp = str;
				break;
			default:
				printf("No es un número real. 2\n");
				return 0;
		}
		st_actual = st_nuevo;
		entrada++;
	}
	if (st_actual == FIN) printf("Entera: %s\nFraccional: %s\nExponencial: %s\n",p_entera,p_fraccion,p_exp);
	else printf("No es un número real. 3\n");
	return 0;
}
