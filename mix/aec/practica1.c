// Programa que calcula el numero PI mediante el metodo    |
// de Monte Carlo basado en circulo de radio 1 inscrito en |
// cuadrado de lado 2.                                     |
// Terminacion controlada por: Numero de iteraciones       |

#include <assert.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>

int main( int   argc, char *argv[] ) {
	
	int i, niteraciones, enCirculo=0;
	double x, y, pi;
	
	if (argc != 2) {
		printf ("Uso: pi numIteraciones \n");
		exit(0);
	}
	niteraciones = atoi(argv[1]);
	
	for (i=1; i<=niteraciones; i++) {
		x = (double) random() / (double) RAND_MAX;
		y = (double) random() / (double) RAND_MAX;
		if ((x*x + y*y) <= 1.0) enCirculo++;
	}
	pi = (4.0 * enCirculo) / (double) i;
	
	printf ("Valor de PI = %.6lf\n", pi);
	printf ("Error       = %.6lf\n", fabs(pi-M_PI));
	return 0;
}
