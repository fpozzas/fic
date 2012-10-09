// Programa que calcula una norma para cada una de las     |
// filas de una matriz bidimensional representada mediante |
// un formato de almacenamiento denso.                |
#include <assert.h>
#include <limits.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>
#include <xmmintrin.h>


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
	
	__m128 rega;
	float * temp = _mm_malloc(sizeof(float)*4,16);
	int ncolsmod = ncols-ncols%4;
	int ncolsceros = ncolsmod+4;
	for (i=0; i<nfilas; i++) {
		normafila = 0;
		for (j=0; j<ncolsmod; j=j+4) {
			///////////
			// Carga
			rega = _mm_load_ps(&(valores[i*ncolsceros+j]));
			// Mult
			rega = _mm_mul_ps(rega,rega);
			// Almacenamiento
			_mm_store_ps(temp,rega);	
			///////////
			normafila += temp[0] + temp[1] + temp[2] + temp[3];
		}
		while (j<ncols){
			normafila += valores[i*ncolsceros+j] * valores[i*ncolsceros+j];
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


void inicializacion(float **pvalores, float **pnorma, int nfilas, int ncols)
{
	int i, j;
	// _mm_malloc
	int ncolsmod = ncols-ncols%4;
	int ncolsceros = ncolsmod+4;
	//if( ((*pvalores)=(float *) _mm_malloc(sizeof(float)*nfilas*ncols,16)) == NULL ) {
	if( ((*pvalores)=(float *) _mm_malloc(sizeof(float)*nfilas*ncolsceros,16)) == NULL ) {
		printf ("error: memoria insuficiente para valores\n");
		exit(-1);
	}

	if( ((*pnorma)=(float *) _mm_malloc(sizeof(float)*nfilas,16)) == NULL ) {
		printf ("error: memoria insuficiente para norma\n");
		exit(-1);
	}
	for (i=0; i<nfilas; i++) {
		for (j=0; j<ncols; j++) {
			(*pvalores) [i*ncolsceros+j] = (float) ( (float) random() / (float) RAND_MAX );
		}
		for (j=j; j<(ncolsceros); j++){
			(*pvalores) [i*ncolsceros+j] = (float) 0;
		}
	}
}


