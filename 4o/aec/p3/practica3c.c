// Programa que calcula una norma para cada una de las     |
// filas de una matriz bidimensional representada mediante |
// un formato de almacenamiento denso.                |
#include <assert.h>
#include <limits.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>


#define INDEX(I,J) [i*ncols+j]

void inicializacion(float **pvalores, float **pnorma, int nfilas, int ncols);

int main( int argc, char *argv[] ) {
	
	float *valores; 
	float *norma;
	float normafila;
	int nfilas, ncols;
	int i, j;
	struct timeval t0, t1, t;
	
	if (argc != 3) {
		printf ("Uso: norma nfilas ncols \n");
		exit(0);
	}
	nfilas = atoi(argv[1]);
	ncols = atoi(argv[2]);

	inicializacion(&valores, &norma, nfilas, ncols);
	assert (gettimeofday (&t0, NULL) == 0);
	
	for (i=0; i<nfilas; i++) {
		normafila = 0;
		for (j=0; j<ncols; j++) {
	    	normafila += valores INDEX(i,j) * valores INDEX(i,j);
		}
		norma[i] = sqrt(normafila);
	}
	
	assert (gettimeofday (&t1, NULL) == 0);
	timersub(&t1, &t0, &t);
	printf ("nfilas      = %ld\n", nfilas);
	printf ("ncols       = %ld\n", ncols);
	printf ("Tiempo      = %ld:%ld(seg:mseg)\n", t.tv_sec, t.tv_usec/1000);
	
	return 0;
}


void inicializacion(float **pvalores, float **pnorma, int nfilas, int ncols)
{
	int i, j;

	if( ((*pvalores)=(float *) malloc(sizeof(float)*nfilas*ncols)) == NULL ) {
		printf ("error: memoria insuficiente para valores\n");
		exit(-1);
	}

	if( ((*pnorma)=(float *) malloc(sizeof(float)*nfilas)) == NULL ) {
		printf ("error: memoria insuficiente para norma\n");
		exit(-1);
	}

	for (i=0; i<nfilas; i++) {
		for (j=0; j<ncols; j++) {
			(*pvalores) INDEX(i,j) = (float) ( (float) random() / (float) RAND_MAX );
		}
	}
}


