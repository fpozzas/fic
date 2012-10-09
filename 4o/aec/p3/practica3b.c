// Programa que calcula una norma para cada una de las     |
// filas de una matriz bidimensional representada mediante |
// un formato de almacenamiento comprimido.                |
#include <assert.h>
#include <limits.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>
#include <xmmintrin.h>

void inicializacion(float ***pvalores, int **pdimfilas, float **pnorma, int nfilas, int ncols, int *nelementos);

int main( int argc, char *argv[] ) {
	
	float **valores, *norma;
	int *dimfilas;
	float normafila, maxfila;
	int nfilas, ncols, nelementos;
	int i, j;
	struct timeval t0, t1, t;
	
	if (argc != 3) {
		printf ("Uso: norma nfilas ncols \n");
		exit(0);
	}
	nfilas = atoi(argv[1]);
	ncols = atoi(argv[2]);

	inicializacion(&valores, &dimfilas, &norma, nfilas, ncols, &nelementos);

	assert (gettimeofday (&t0, NULL) == 0);
	
	__m128 rega;
	float * temp = _mm_malloc(sizeof(float)*4,16);
	for (i=0; i<nfilas; i++) {
		normafila = 0;
		int dimfilamod = dimfilas[i]-dimfilas[i]%4;
		for (j=0; j<dimfilamod; j=j+4) {
			///////////
			// Carga
			rega = _mm_load_ps(&(valores[i][j]));
			// Mult
			rega = _mm_mul_ps(rega,rega);
			// Almacenamiento
			_mm_store_ps(temp,rega);	
			///////////
			normafila += temp[0] + temp[1] + temp[2] + temp[3];
		}
		while (j<dimfilas[i]){
			normafila += valores[i][j] * valores[i][j];
			j++;
		}
		norma[i] = sqrt(normafila);
		printf("%f\n",norma[i]);
	}
	
	assert (gettimeofday (&t1, NULL) == 0);
	timersub(&t1, &t0, &t);
	printf ("nfilas      = %ld\n", nfilas);
	printf ("ncols       = %ld\n", ncols);
	printf ("Tiempo      = %ld:%ld(seg:mseg)\n", t.tv_sec, t.tv_usec/1000);
	
	return 0;
}


void inicializacion(float ***pvalores, int **pdimfilas, float **pnorma, int nfilas, int ncols, int *nelementos)
{
	int ncolsfila;
	int i, j;

	if( ((*pdimfilas)=(int *) malloc(sizeof(int)*nfilas)) == NULL ) {
		printf ("error: memoria insuficiente para dimfilas\n");
		exit(-1);
	}
	if( ((*pvalores)=(float **) malloc(sizeof(float)*nfilas)) == NULL ) {
		printf ("error: memoria insuficiente para valores\n");
		exit(-1);
	}
	for (i=0; i<nfilas; i++) {
		ncolsfila = (int)(rand()%(9*i+1));
		if ( ncolsfila > ncols ) ncolsfila=ncols;
		(*pdimfilas)[i] = ncolsfila;
		// _mm_malloc
		if( ((*pvalores)[i]=(float *) _mm_malloc(sizeof(float)*(*pdimfilas)[i],16)) == NULL ) {
			printf ("error: memoria insuficiente para valores[%d]\n",i);
			exit(-1);
		}
	}
	if( ((*pnorma)=(float *) malloc(sizeof(float)*nfilas)) == NULL ) {
		printf ("error: memoria insuficiente para norma\n");
		exit(-1);
	}
	(*nelementos) = 0;
	for (i=0; i<nfilas; i++) {
		for (j=0; j<(*pdimfilas)[i]; j++) {
			(*pvalores)[i][j] = (float) ( (float) random() / (float) RAND_MAX );
		}
		(*nelementos) += (*pdimfilas)[i];
	}
}
