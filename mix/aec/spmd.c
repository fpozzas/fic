/*
 *    SPMD example using PVM
 */

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <pvm3.h>

void configure_parallel_program(int argc, char *argv[], int *nproc, int *mytid, int **tids, int *me);
void dowork( int me, int mytid, int *tids, int nproc );
void print_tids_array( int mytid, int *tids, int nproc );

int main( int argc, char *argv[] )
{
    int i;
    int nproc;                 /* number of processes */
    int mytid;                 /* my process id */
    int *tids;                 /* array of 'nproc' process ids */
    int me;                    /* my process number */
	
    configure_parallel_program(argc,argv,&nproc,&mytid,&tids,&me);
	
    /*-------------------------------------------------------------------------
     * All nproc processes are initialized now and can send information 
     *   to each other using tids[0] through tids[nproc-1]
     * For each process, 'me' is a process number between 0 and (nproc-1)
     *   (computed as the index in 'tids' array where 'mytid' is stored)
     *-----------------------------------------------------------------------*/
    print_tids_array(mytid,tids,nproc);
	
    dowork( me, mytid, tids, nproc );
	
    /* program finished exit pvm */
    if( pvm_exit() < 0 ) {
		pvm_perror ("ERROR main(): pvm_exit \n");
    }
    exit(1);
}

/* Simple example initializes mytid and tids[] in all the processes */
void configure_parallel_program(int argc, char *argv[], int *nproc, int *mytid, int **tids, int *me)
{
    int i, cc;
    int ptid;
	
    /* enroll in pvm */
    (*mytid) = pvm_mytid();
	
    /* find out if I am parent or child */
    ptid = pvm_parent();
	
    if( ptid < 0 )       /* then I am the parent */
    {
		
		printf("%d: Master process\n",(*mytid));
		/* read information from the command line */
		if (argc != 2) {
			printf ("%d: Master process usage 'spmd nproc' \n",(*mytid));
			pvm_perror("ERROR configure_parallel_program(): Command line of the master process \n");
			pvm_exit();
			exit(0);
		}
		(*nproc) = atoi(argv[1]);
		printf("%d: Master process parsed the command line: nproc = %d\n",(*mytid),(*nproc));
		if( ( (*tids)=(int *)malloc((*nproc)*sizeof(int)) ) == NULL ) {
			pvm_perror ("ERROR configure_parallel_program(): Not enough memory in the master process \n");
			pvm_exit();
			exit(0);
		}
		
		(*me) = 0;
		(*tids)[0] = (*mytid);
		/* start up copies of myself */
		if( (cc=pvm_spawn("spmd", (char**)0, 0, "", (*nproc)-1, &(*tids)[1])) < (*nproc)-1 ) {
			pvm_perror ("ERROR configure_parallel_program(): Not enough processes created \n");
			pvm_exit();
			exit(0);
		}
		
		/* multicast tids array to children */
		if( pvm_initsend( PvmDataDefault ) < 0 ) {
			pvm_perror ("ERROR configure_parallel_program(): pvm_initsend \n");
			pvm_exit();
			exit(0);
		}
		if( pvm_pkint(nproc, 1, 1) < 0 ) {
			pvm_perror ("ERROR configure_parallel_program(): pvm_pkint(nproc) \n");
			pvm_exit();
			exit(0);
		}
		if( pvm_pkint((*tids), (*nproc), 1) < 0 ){
			pvm_perror ("ERROR configure_parallel_program(): pvm_pkint(tids) \n");
			pvm_exit();
			exit(0);
		}
		if( pvm_mcast(&(*tids)[1], (*nproc)-1, 0) ) {
			pvm_perror ("ERROR configure_parallel_program(): pvm_mcast \n");
			pvm_exit();
			exit(0);
		}
		
    }
    else    /* I am a child */
    {
		printf("%d: Slave process\n",(*mytid));
		
		/* there is no information to read from the command line */
		if (argc != 1) {
			printf ("%d: Slave process usage 'spmd' \n",(*mytid));
			pvm_perror("ERROR configure_parallel_program(): Command line of the slave process \n");
			pvm_exit();
			exit(0);
		}
		
		/* receive nproc and tids array */
		if( pvm_recv(-1, 0) < 0 ) {
			pvm_perror ("ERROR configure_parallel_program(): pvm_recv \n");
			pvm_exit();
			exit(0);
		}
		if( pvm_upkint(nproc, 1, 1) < 0 ) {
			pvm_perror ("ERROR configure_parallel_program(): pvm_upkint(nproc) \n");
			pvm_exit();
			exit(0);
		}
		printf("%d: Slave process unpacked nproc=%d\n",(*mytid),(*nproc));
		if( ( (*tids)=(int *)malloc((*nproc)*sizeof(int)) ) == NULL ) {
			pvm_perror ("ERROR configure_parallel_program(): Not enough memory in the slave process \n");
			pvm_exit();
			exit(0);
		}
		if( pvm_upkint(&(*tids)[0], (*nproc), 1) < 0 ) {
			pvm_perror ("ERROR configure_parallel_program(): pvm_upkint(tids) \n");
			pvm_exit();
			exit(0);
		}
		for( i=1; i<(*nproc) ; i++ )
			if( (*mytid) == (*tids)[i] ){ 
				(*me) = i; 
				break; 
			}
		
	}
}


/* Simple example sends a message from child processes to the parent process */
void dowork( int me, int mytid, int *tids, int nproc )
{
	int i;
	int token;
	int count  = 1;
	int stride = 1;
	int msgtag = 4;
	
	if( me == 0 )
	{
		for( i=1; i<nproc; i++ ) {
			if( pvm_recv( tids[i], msgtag ) < 0 ) {
				pvm_perror ("ERROR dowork(): pvm_recv \n");
				pvm_exit();
				exit(0);
			}
			if( pvm_upkint( &token, count, stride ) < 0 ) {
				pvm_perror ("ERROR dowork(): pvm_upkint \n");
				pvm_exit();
				exit(0);
			}
			printf("%d: message token='%d' received from %d\n",mytid,token,tids[i]);
		}
		
	}
	else
	{
		token = 100 + me;
		if( pvm_initsend( PvmDataDefault ) < 0 ) {
			pvm_perror ("ERROR dowork(): pvm_initsend \n");
			pvm_exit();
			exit(0);
		}
		if( pvm_pkint( &token, count, stride ) < 0 ) {
			pvm_perror ("ERROR dowork(): pvm_pkint \n");
			pvm_exit();
			exit(0);
		}
		if( pvm_send( tids[0], msgtag ) < 0 ) {
			pvm_perror ("ERROR dowork(): pvm_send \n");
			pvm_exit();
			exit(0);
		}
		printf("%d: message token='%d' sent to %d\n",mytid,token,tids[0]);
	}
}




/* Simple example sends a message from child processes to the parent process */
void print_tids_array( int mytid, int *tids, int nproc )
{
    int i;
	
    printf ("%d: tids array [ ",mytid);
    for( i=0; i<nproc ; i++ ) {
        printf ("%d ",tids[i]); 
    }
    printf ("]\n");
}
