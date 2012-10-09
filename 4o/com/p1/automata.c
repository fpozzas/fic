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

int getestado(int st, int simb){
	switch(st){
		case 0:
			if (simb==1) return 2;
			else if (simb==4) return 1;
			break;
		case 1:
			if (simb==1) return 2;
			break;
		case 2:
			if (simb==1) return 2;
			else if (simb==2) return 3;
			else if (simb==3) return 5;
			else if (simb==5) return 8;
			break;
		case 3:
			if (simb==1) return 4;
			break;
		case 4:
			if (simb==1) return 4;
			else if (simb==3) return 5;
			else if (simb==5) return 8;
			break;
		case 5:
			if (simb==1) return 7;
			else if (simb==4) return 6;
			break;
		case 6:
			if (simb==1) return 7;
			break;
		case 7:
			if (simb==1) return 7;
			else if (simb==5) return 8;
			break;
		default: return 9999;	
	}
	return 9999;
}
int main(int argc, char * argv[]){
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
			printf("No es un número real.\n");
			return 0;
		}
		st_nuevo = getestado(st_actual,simbolo);
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
				printf("No es un número real.\n");
				return 0;
		}
		st_actual = st_nuevo;
		entrada++;
	}
	if (st_actual == FIN) printf("Entera: %s\nFraccional: %s\nExponencial: %s\n",p_entera,p_fraccion,p_exp);
	else printf("No es un número real.\n");
	return 0;
}
