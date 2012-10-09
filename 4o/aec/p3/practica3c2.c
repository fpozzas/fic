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

	__m128 rega,regb,regc,regd,regnorma,regtemp;
	float * temp = _mm_malloc(sizeof(float)*4,16);
	int nfilasmod = nfilas-nfilas%4;
	int ncolsmod = ncols-ncols%4;
	int ncolsceros = ncolsmod+4;
	for (i=0; i<nfilasmod; i=i+4) {
		regnorma = _mm_setzero_ps();
		int incols = i*ncolsceros;
		int i1ncols = (i+1)*ncolsceros;
		int i2ncols = (i+2)*ncolsceros;
		int i3ncols = (i+3)*ncolsceros;
		int index[4];
		for (j=0; j<ncolsmod; j=j+4) {
			index[0] = incols+j;
			index[1] = i1ncols+j;
			index[2] = i2ncols+j;
			index[3] = i3ncols+j;
			///////////
			// Carga
			rega = _mm_load_ps(&(valores[index[0]]));
			regb = _mm_load_ps(&(valores[index[1]]));
			regc = _mm_load_ps(&(valores[index[2]]));
			regd = _mm_load_ps(&(valores[index[3]]));
			// Reordenacion
			_MM_TRANSPOSE4_PS(rega,regb,regc,regd);
			// Mult
			rega = _mm_mul_ps(rega,rega);
			regb = _mm_mul_ps(regb,regb);
			regc = _mm_mul_ps(regc,regc);
			regd = _mm_mul_ps(regd,regd);
			// Sumar a normafila
			regnorma = _mm_add_ps(regnorma,rega);
			regnorma = _mm_add_ps(regnorma,regb);
			regnorma = _mm_add_ps(regnorma,regc);
			regnorma = _mm_add_ps(regnorma,regd);
		}
		while (j<ncols){
			index[0] = incols+j;
			index[1] = i1ncols+j;
			index[2] = i2ncols+j;
			index[3] = i3ncols+j;
			temp[0] = valores[index[0]];
			temp[1] = valores[index[1]];
			temp[2] = valores[index[2]];
			temp[3] = valores[index[3]];
			regtemp = _mm_load_ps(temp);
			regtemp = _mm_mul_ps(regtemp,regtemp);
			regnorma = _mm_add_ps(regnorma,regtemp);
			j++;
		}
		// Almacenamiento
		regnorma = _mm_sqrt_ps(regnorma);
		_mm_store_ps(&(norma[i]),regnorma);
		printf("%f\n",norma[i]);
		printf("%f\n",norma[i+1]);
		printf("%f\n",norma[i+2]);
		printf("%f\n",norma[i+3]);
	}
	while(i<nfilas){
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
		i++;
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


