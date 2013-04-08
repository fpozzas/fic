#include <pvm3.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <math.h>
#include <stdlib.h>
#include <sys/time.h>

#define TAGITER 345
#define TAGAPROX 543

int main(int argc, char * argv[])
{	
	if (pvm_parent()<0) work_master(argc,argv);
	else work_slave();

	pvm_exit();
	exit(0);
}

double montecarlo(int N){
	double x, y, pi;
	int i;
	int enCirculo = 0;
	
	for (i=1; i<=N; i++) {
		x = (double) random() / (double) RAND_MAX;
		y = (double) random() / (double) RAND_MAX;
		if ((x*x + y*y) <= 1.0) enCirculo++;
	}
	pi = (4.0 * enCirculo) / (double) i;
	return pi;
};

double prdg_ms(int N, int nproc){
	double aproxproc,aproxtotal;
	int i;
	int iteraciones = N / nproc;
	int *tids;
	/* CREACIÓN */
	if( ( tids=(int *)malloc(nproc*sizeof(int)) ) == NULL ) {
		pvm_perror ("ERROR prdg_ms(): Not enough memory in the master process \n");
		pvm_exit();
		exit(0);
	}
	if( (i=pvm_spawn("ms", (char**)0, 0, "", nproc, tids)) < nproc ) {
		pvm_perror ("ERROR prdg_ms(): Not enough processes created \n");
		pvm_exit();
		exit(0);
	}
	if( pvm_initsend( PvmDataDefault ) < 0 ) {
		pvm_perror ("ERROR prdg_ms(): pvm_initsend \n");
		pvm_exit();
		exit(0);
	}
	if( pvm_pkint(&iteraciones, 1, 1) < 0 ) {
		pvm_perror ("ERROR prdg_ms(): pvm_pkint(iteraciones) \n");
		pvm_exit();
		exit(0);
	}
	for (i=0;i<nproc;i++){
		if( pvm_send(tids[0], TAGITER ) < 0 ) {
			pvm_perror ("ERROR prdg_ms(): pvm_send \n");
			pvm_exit();
			exit(0);
		}
	}
	/* RECEPCIÓN */
	for( i=0; i<nproc; i++ ) {
		if( pvm_recv(-1, TAGAPROX ) < 0 ) {
			pvm_perror ("ERROR dowork(): pvm_recv \n");
			pvm_exit();
			exit(0);
		}
		if( pvm_upkdouble(&aproxproc, 1, 1 ) < 0 ) {
			pvm_perror ("ERROR dowork(): pvm_upkint \n");
			pvm_exit();
			exit(0);
		}
		aproxtotal += aproxproc;
	}
	return aproxtotal/nproc;
}
double prdg_spmd(int N, int nproc){
	double aproxproc,aproxtotal;
	int i;
	int iteraciones = N / nproc;
	int *tids;
	/* CREACIÓN */
	if( ( tids=(int *)malloc(nproc*sizeof(int)) ) == NULL ) {
		pvm_perror ("ERROR prdg_spmd(): Not enough memory in the master process \n");
		pvm_exit();
		exit(0);
	}
	if( pvm_spawn("spmd", (char**)0, 0, "", nproc, tids) < nproc ) {
		pvm_perror ("ERROR prdg_spmd(): Not enough processes created \n");
		pvm_exit();
		exit(0);
	}
	if( pvm_initsend( PvmDataDefault ) < 0 ) {
		pvm_perror ("ERROR prdg_spmd(): pvm_initsend \n");
		pvm_exit();
		exit(0);
	}
	if( pvm_pkint(&iteraciones, 1, 1) < 0 ) {
		pvm_perror ("ERROR prdg_spmd(): pvm_pkint(iteraciones) \n");
		pvm_exit();
		exit(0);
	}
	if( pvm_mcast(tids, nproc, 0) ) {
		pvm_perror ("ERROR prdg_spmd(): pvm_mcast \n");
		pvm_exit();
		exit(0);
	}
	/* RECEPCIÓN */
	for( i=0; i<nproc; i++ ) {
		if( pvm_recv(-1, TAGAPROX ) < 0 ) {
			pvm_perror ("ERROR dowork(): pvm_recv \n");
			pvm_exit();
			exit(0);
		}
		if( pvm_upkdouble(&aproxproc, 1, 1 ) < 0 ) {
			pvm_perror ("ERROR dowork(): pvm_upkint \n");
			pvm_exit();
			exit(0);
		}
		aproxtotal += aproxproc;
	}
	return aproxtotal/nproc;
	
}

int work_master(int argc,char ** argv){
	/* Pasear argv */
	int flag_spmd, N, nproc;
	double aproxpi;
	if (argc!=4){print_help(); exit(0);}
	if (!strcmp(argv[1],"ms")) flag_spmd = 0;
	else if (!strcmp(argv[1],"spmd")) flag_spmd = 1;
	else {print_help(); exit(0);}
	if ((N=strtol(argv[2],(char**)NULL,10))==0) {printf("Número de iteraciones inválido");exit(-1);}
	if ((nproc=strtol(argv[3],(char**)NULL,10))==0) {printf("Número de procesadores inválido");exit(-1);}
	
	if (flag_spmd) aproxpi = prdg_spmd(N,nproc);
	else aproxpi = prdg_ms(N,nproc);
	printf("Aproximación de pi: %f",aproxpi);
}



int work_slave(){
	int iteraciones;
	double aproxpi;
	
	/* RECEPCIÓN */
	if( pvm_recv(-1, TAGITER) < 0 ) {
		pvm_perror ("ERROR work_slave(): pvm_recv \n");
		pvm_exit();
		exit(0);
}
	if( pvm_upkint(&iteraciones, 1, 1) < 0 ) {
		pvm_perror ("ERROR work_slave(): pvm_upkint(iteraciones) \n");
		pvm_exit();
		exit(0);
	}

	aproxpi = montecarlo(iteraciones);
	
	
	/* ENVIO */
	if( pvm_initsend( PvmDataDefault ) < 0 ) {
		pvm_perror ("ERROR work_slave(): pvm_initsend \n");
		pvm_exit();
		exit(0);
	}
	if( pvm_pkdouble( &aproxpi, 1, 1 ) < 0 ) {
		pvm_perror ("ERROR work_slave(): pvm_pkint \n");
		pvm_exit();
		exit(0);
	}
	if( pvm_send( pvm_parent(), TAGAPROX ) < 0 ) {
		pvm_perror ("ERROR work_slave(): pvm_send \n");
		pvm_exit();
		exit(0);
	}	
}



int print_help(void){
	printf("Uso: montecarlo <paradigma> <iteraciones> <procesadores>\n");
	printf("  <paradigma>:    ms | spmd\n");
	printf("  <iteraciones>:  numero de iteraciones\n");
	printf("  <procesadores>: numero de procesadores\n");
}



