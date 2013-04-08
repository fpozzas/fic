/*
AUTOR:font alonso, juan:infdfn01
AUTOR:fernandez nunez, daniel:infdfn01
*/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <time.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <grp.h>
#include <pwd.h>


#define MAXLINEA 1024
#define MAXARRAY 1000
#define LINEA 25
#define MAXNOMBRE 256
#define MAXFICHEROS 100
#define SHM_MODOS 00755
#define MAXLISTA 50

// Modos para manejar las funciones de los jobs
#define IMPRIME_ALL 2
#define IMPRIMIR 1
#define BORRAR 0


#define GETPRIOERROR -100

// Modos para las funciones de entornos
#define PUT 0
#define SUS 1
#define GETENV 2
#define PUTENV 3

/* ESTRUCTURAS Y VARIABLES GLOBALES */

struct tMalloc_lista{
	void * pt;
	int tamano;
} malloc_lista[MAXARRAY];
int malloc_lista_size;

struct tShared_lista{
	int clave;
	void * pt;
} shared_lista[MAXARRAY];
int shared_lista_size;

struct tMmapl{
	void * pt;
	int tamano;
	char * nombre;
} mmap_lista[MAXARRAY];
int mmap_lista_size;

void * direccion_entrada;
void * direccion_trozos;

char prompt[MAXLINEA]="$ ";

// Lista de procesos en segundo plano
struct myproc{
	pid_t pid;
	time_t inicio;
	int prio;
	int estado;
	char * comando;
	int terminado;
	char * strestado;
}spl[MAXLISTA];;

// Lista de rutas de busqueda
char * rbl[MAXLISTA];

extern char ** environ;
char ** envmain;

// Copias de I/O/ERR estadares
int copiaEE;
int copiaSE;
int copiaES;
/* FIN DE ESTRUCTURAS Y VARIABLES GLOBALES */


char **trocear(char * entrada, char * s) {
	static char * tok[MAXLINEA];
	tok[0]=strtok(entrada,s);
	int i=1;
	while((tok[i]=strtok(NULL,s))!=NULL) i++;
	return tok;
}

int procesar(char ** trozos){
    if (trozos[0]==NULL) return 0;
    else if (strcmp(trozos[0],"exit")==0) comm_exit();
    else if (strcmp(trozos[0],"quit")==0) comm_exit();
    else if (strcmp(trozos[0],"autores")==0) comm_autores();
    else if (strcmp(trozos[0],"chdir")==0) comm_chdir(trozos);
    else if (strcmp(trozos[0],"prompt")==0) comm_prompt(trozos);
    else if (strcmp(trozos[0],"pid")==0) comm_pid(trozos);
    else if (strcmp(trozos[0],"fork")==0) comm_fork();
    else if (strcmp(trozos[0],"malloc")==0) comm_malloc(trozos);
	else if (strcmp(trozos[0],"display")==0) comm_display(trozos);
	else if (strcmp(trozos[0],"free")==0) comm_free(trozos);
	else if (strcmp(trozos[0],"stat")==0) comm_stat(trozos);
	else if (strcmp(trozos[0],"delete")==0) comm_delete(trozos);	
	else if (strcmp(trozos[0],"list")==0) comm_list(trozos);	
	else if (strcmp(trozos[0],"mmap")==0) comm_mmap(trozos);	
	else if (strcmp(trozos[0],"munmap")==0) comm_munmap(trozos);	
	else if (strcmp(trozos[0],"read")==0) comm_read(trozos);	
	else if (strcmp(trozos[0],"write")==0) comm_write(trozos);	
	else if (strcmp(trozos[0],"rec")==0) comm_rec(trozos);	
	else if (strcmp(trozos[0],"shared-creat")==0) comm_sharedcreat(trozos);	
	else if (strcmp(trozos[0],"shared-del")==0) comm_shareddel(trozos);	
	else if (strcmp(trozos[0],"detach")==0) comm_detach(trozos);	
	else if (strcmp(trozos[0],"shared-info")==0) comm_sharedinfo(trozos);	
 	else if (strcmp(trozos[0],"shared-cp")==0) comm_sharedcp(trozos);	
 	else if (strcmp(trozos[0],"shared-rm")==0) comm_sharedrm(trozos[1]);	
 	else if (strcmp(trozos[0],"direcciones")==0) comm_direcciones(trozos);	
 	else if (strcmp(trozos[0],"shared-mv")==0){
 		if (trozos[1]==NULL) {printf("Numero de parametros incorrectos.\n"); return -1;}
 		char arg[strlen(trozos[1])];
 		strcpy(arg,trozos[1]);
 		if ((comm_sharedcp(trozos))==0)
 			comm_sharedrm(arg);
 	}
 	// Comandos de p2
 	else if (strcmp(trozos[0],"path")==0) comm_path(trozos);	
 	else if (strcmp(trozos[0],"exec")==0) comm_exec(trozos+1);	
 	else if (strcmp(trozos[0],"getpriority")==0) comm_getpriority(trozos);	
 	else if (strcmp(trozos[0],"setpriority")==0) comm_setpriority(trozos);	
 	else if (strcmp(trozos[0],"jobs")==0) comm_jobs(trozos,IMPRIMIR); 	
	else if (strcmp(trozos[0],"cleanjobs")==0) comm_jobs(trozos,BORRAR);
	// Comandos de p3
	else if (strcmp(trozos[0],"entorno")==0) comm_entorno(trozos);
	else if (strcmp(trozos[0],"entornos")==0) comm_entornos(trozos);
	else if (strcmp(trozos[0],"get")==0) comm_get(trozos);
	else if (strcmp(trozos[0],"put")==0) comm_putenv(trozos,PUT);
	else if (strcmp(trozos[0],"sus")==0) comm_putenv(trozos,SUS);
	else if (strcmp(trozos[0],"creds")==0) comm_creds();
	else if (strcmp(trozos[0],"setuid")==0) comm_setuid(trozos);
	// Comandos de p4
	else if (strcmp(trozos[0],"pipe")==0) comm_pipe(trozos);
	else comm_com(trozos);
}

int comm_exit(){
    exit(0);
}

int comm_autores(){
    printf("Juan Font Alonso (infjfa00)\n");
    printf("Daniel Fernández Núñez (infdfn01)\n"); 
    return 0;
}

int comm_chdir(char ** trozos){
    int codigo;
    if (trozos[1]==NULL) printf("%s\n",get_current_dir_name());
    else if (chdir(trozos[1])==-1) perror ("Imposible cambiar directorio");
    return 0;
}

int comm_prompt(char ** trozos){
    if (trozos[1]==NULL) return 0;
    else strcpy(prompt,strcat(trozos[1]," "));
    return 0;
}

int comm_pid(char ** trozos){
    if (trozos[1]==NULL) printf("PID del proceso: %i\n",getpid()); 
    else if (strcmp(trozos[1],"-p")==0) printf("PID del proceso: %i\nPID del padre: %i\n",getpid(),getppid());
    else printf("Opcion invalida.\n");
    return 0;
}

int comm_fork() {
    fork();
    waitpid(-1,NULL,0);
    return 0;
}

int imprime_malloc_lista(){
	int i=0;
	while(malloc_lista_size>=i){
		if (malloc_lista[i].pt!=NULL) printf("[%p]\t%i\n",malloc_lista[i].pt,malloc_lista[i].tamano);
		i++;
	}
}

int comm_malloc(char ** trozos){
    void * dirmem;
    long tam;
    if (trozos[1]!=NULL){
        tam = strtol(trozos[1], (char **)NULL, 10);
        if (tam!=0) {
            dirmem = malloc(tam);
            printf("Reservados %i bytes en %p\n",tam,dirmem);
			int i = 0;
            while(malloc_lista[i].pt!=NULL) i++;
			if (i>=MAXARRAY) {printf("Array lleno."); return -1;}
			malloc_lista[i].pt = dirmem;
			malloc_lista[i].tamano = tam;
			if (malloc_lista_size<i) malloc_lista_size = i;
        }
        else printf("No se ha reservado memoria.\n");
    }
    else imprime_malloc_lista();
    return 0;
}

int comm_free(char ** trozos){
	void * dirmem;
	int flag=0;
	if (trozos[1]==NULL){
		printf("Se necesitan mas argumentos.\n");
		return -1;
	} else { 
		if((strcmp(trozos[1],"-f"))==0){
			flag = 1;
			if (trozos[2]!=NULL) dirmem = (void *)strtoul(trozos[2], (char **)NULL, 0);
			else {
				printf("Se necesitan mas argumentos.\n");
				return -1;
			}
		} else dirmem = (void *)strtoul(trozos[1], (char **)NULL, 0);
	}
	int i=0;
	while((malloc_lista[i].pt!=dirmem) && (malloc_lista[i].pt!=NULL)) i++;
	if ((malloc_lista[i].pt!=NULL) || (flag==1)) {
		free(malloc_lista[i].pt);
		malloc_lista[i].pt=NULL;
		printf("Se ha liberado memoria.\n");
	}
	else printf("No esta en la lista de memoria.\n");
}


char * devuelve_caracter (char c){
  static char aux[3];
  if (c=='\n')
    return ("\\n");
  if (c=='\t')
    return ("\\t");
  if (!isalnum (c))
    return ("  ");
  sprintf (aux," %c",c);
  return (aux);
}



void mostrar_dir (char * dir, int cont){
  int i,j;
  int indice;
  int nlines, ultima;
  nlines=cont/LINEA;
  ultima=cont%LINEA;
  for (i=0; i<nlines; i++){
    for (j=0; j<LINEA; j++){
        indice= i*LINEA + j;
		printf ("%s ",devuelve_caracter(dir[indice]));
       }
     printf("\n");
     for (j=0; j<LINEA; j++){
        indice= i*LINEA + j;
        printf ("%3x",dir[indice]);
       }  
      printf ("\n");
      }
   if (ultima!=0){   
     for (j=0; j<ultima; j++){
        indice= nlines*LINEA + j;
		printf ("%s ",devuelve_caracter(dir[indice]));
       }
	for(j=0; j<LINEA-ultima; j++) printf("   ");
     printf("\n");
     for (j=0; j<ultima; j++){
        indice= nlines*LINEA + j;
        printf ("%3x",dir[indice]);
       }
      printf ("\n");
   }
}

int comm_display(char ** trozos){

	if (trozos[1]==NULL){
		printf("Se necesita una direccion de memoria.\n");
		return -1;
	}
	int cont = 25;
	if (trozos[2]!=NULL) cont = strtol(trozos[2],(char **)NULL,10); 
	char * dirmem = (char *)strtoul(trozos[1], (char **)NULL, 0);
	mostrar_dir(dirmem,cont);
}

char *devolver_permisos (int modos){
	static char resultado[10];
	static char rwxkey[8][4] = { "---", "--x", "-w-", "-wx","r--", "r-x", "rw-", "rwx" };
	resultado[0] = rwxkey[((modos >> 6) & 0x07)][0];
	resultado[1] = rwxkey[((modos >> 6) & 0x07)][1];
	resultado[2] = rwxkey[((modos >> 6) & 0x07)][2];
	resultado[3] = rwxkey[((modos >> 3) & 0x07)][0];
	resultado[4] = rwxkey[((modos >> 3) & 0x07)][1];
	resultado[5] = rwxkey[((modos >> 3) & 0x07)][2];
	resultado[6] = rwxkey[  modos       & 0x07 ][0];
	resultado[7] = rwxkey[  modos       & 0x07 ][1];
	resultado[8] = rwxkey[  modos       & 0x07 ][2];
	resultado[9]= '\0';
	return resultado;
}

int comm_stat(char ** trozos){
	if (trozos[1]==NULL) printf("Se debe proporcionar el nombre de un fichero.\n");
	else{
		struct stat buf;
		int cod = stat(trozos[1],&buf);
		if (cod<0){
			perror("Error");
			return -1;
		}
		printf("Nombre: %s\n", trozos[1]);
		printf("Tamano: %i Bytes\n",buf.st_size);
		printf("Permisos: %s\n", devolver_permisos(buf.st_mode));
		printf("Ultimo acceso: %s",ctime(&buf.st_atime));
	}
}

int comm_delete(char ** trozos){
	if (trozos[1]==NULL) {
		printf("Se debe proporcionar el nombre de un fichero.\n");
		return -1;
	}
	int cod = remove(trozos[1]);
	if (cod<0) {
		perror("Error al eliminar");
		return -2;
	}
	return 0;
}


int comm_list(char ** trozos){
    char dirname[256];
    int flag = 0;
    if (trozos[1]==NULL) strcpy(dirname,".");
    else if (strcmp(trozos[1],"-l")==0) {
        flag = 1;
        if (trozos[2]==NULL) strcpy(dirname,".");
        else strcpy(dirname,trozos[2]);
    }
    else strcpy(dirname,trozos[1]);
	struct dirent **namelist;
    int n;
	n = scandir(dirname, &namelist, 0, alphasort);
    if (n<0) {
    	perror("Error al listar directorio");
		return -1;
	}
	int i;
	struct stat buf;
	if (flag==1){
		printf("MODOS\t\tTAMANO\tULTIMO ACCESO\t\t\tNOMBRE\n");
		for (i=0;i<n;i++) {
			if ((stat(namelist[i]->d_name,&buf))<0){
				perror("Error al listar archivo");
				return -1;
			}
			char * ult_acceso = (char *)ctime(&buf.st_atime);
			printf("%s\t%i\t%.*s\t\%s\n",devolver_permisos(buf.st_mode),buf.st_size,strlen(ult_acceso)-1,ult_acceso,namelist[i]->d_name);
		}
	}
	else {
		for (i=0;i<n;i++) printf("%s\t", namelist[i]->d_name);
		printf("\n");
	}

}

int imprime_mmap_lista(){
	int i=0;
	while (mmap_lista_size>=i){
		if (mmap_lista[i].nombre!=NULL)
			printf("[%p]\t%i Bytes\t%s\n",mmap_lista[i].pt,mmap_lista[i].tamano,mmap_lista[i].nombre);
		i++;
	}
}
int comm_mmap(char ** trozos){
	if (trozos[1]!=NULL){
		int fd;
		if ((fd=open(trozos[1],O_RDONLY))<0){
			perror("Error al mapear");
			return -1;
		}
		struct stat buf; 
		if ((stat(trozos[1],&buf))<0){
			perror("Error al mapear");
			return -1;
		}
		void * p = mmap(NULL,buf.st_size,PROT_READ,MAP_PRIVATE,fd,0);
		if (p==(void *)0xffffffff) {
			perror("Error al mapear");
			return -1;
		}
		int i=0;
		while (mmap_lista[i].nombre!=NULL) i++;
		if (i>=MAXARRAY) {printf("Array lleno."); return -1;}
		mmap_lista[i].pt = p;
		mmap_lista[i].tamano = buf.st_size;
		mmap_lista[i].nombre = (char *)malloc(sizeof(char)*256);
		strcpy(mmap_lista[i].nombre,trozos[1]);
		if (i+1>mmap_lista_size) mmap_lista_size=i+1;
 		printf("Mapeado en %p\n",p);
	}
	else imprime_mmap_lista();
}

int comm_munmap(char ** trozos){
	int flag = 0;
	void * dirmem;
	if (trozos[1]!=NULL){
		if ((strcmp(trozos[1],"-f"))==0){
			flag = 1;
			if (trozos[2]!=NULL) dirmem = (void *)strtoul(trozos[2], (char **)NULL, 0);
			else {
				printf("Se necesitan mas argumentos.\n");
				return -1;
			}
		} else dirmem = (void *)strtoul(trozos[1], (char **)NULL, 0);
	} else {
		printf("Se necesitan mas argumentos.\n");
		return -1;
	}
	int i = 0;
	
	while((mmap_lista[i].pt!=dirmem) && (mmap_lista[i].pt!=NULL)) i++;
	if (mmap_lista[i].pt!=NULL) {
		munmap(mmap_lista[i].pt,mmap_lista[i].tamano);
		mmap_lista[i].pt=NULL;
		mmap_lista[i].nombre=NULL;
	}
	else if (flag==1){
		// tamano???
		munmap(dirmem,0);
	}
	else printf("No esta en la lista de mmap.\n");
}

void * fun_read(void * dirmem, char * fichero){
    int fd;
	if ((fd=open(fichero,O_RDONLY))<0) (void*)-1;
	struct stat buf;
	if ((stat(fichero,&buf))<0) (void*)-1;
	if (dirmem==(void*)0) dirmem = malloc(buf.st_size);
	if ((read(fd,dirmem,buf.st_size))<0) return (void*)-1;
	return dirmem;
}

int comm_read(char ** trozos){
	if (trozos[2]==NULL){
		printf("Se necesitan mas argumentos.\n");
		return -1;
	}
	void * dirmem = (void *)strtoul(trozos[2], (char **)NULL, 0);
	if ((fun_read(dirmem,trozos[1]))==(void*)-1){
		perror("Error en read");
		return -1;
	}
	printf("Se ha escrito en %p.\n",dirmem);
	return 0;
}

int fun_write(void * dirmem, char * file, int cont, int forzar,int permisos){
	int fd;
	int opciones;
	if (forzar==0) opciones = O_WRONLY | O_CREAT | O_EXCL;
	else opciones = O_WRONLY | O_CREAT | O_TRUNC;
	if ((fd=open(file,opciones,permisos))<0) return -1;
	if ((write(fd,dirmem,cont))<0) { close(fd); return -1; }
	close(fd);
	return 0;
}


int comm_write(char ** trozos){
	int flag = 0;
	char file[256];
	void * dirmem;
	int cont;
	if (trozos[3]==NULL){ printf("Se necesitan mas argumentos.\n"); return -1;}
	if ((strcmp(trozos[1],"-f"))==0) {
		if (trozos[4]==NULL) { printf("Se necesitan mas argumentos.\n"); return -1;}
		flag = 1;
		strcpy(file,trozos[2]);
		dirmem = (void *)strtoul(trozos[3], (char **)NULL, 0);
		cont = strtol(trozos[4], (char **)NULL, 10);
	} else{
		strcpy(file,trozos[1]);
		dirmem = (void *)strtoul(trozos[2], (char **)NULL, 0);
		cont = strtol(trozos[3], (char **)NULL, 10);
	}
	if ((fun_write(dirmem,file,cont,flag,SHM_MODOS))<0) {
		perror("Error");
		return -1;
	}
	else printf("Se ha escrito con exito.\n");
}


#define TAMANO 1024
#define ANTES -1
#define DESPUES 1
void recursiva (int n, int liberar, int delay)
{
    char automatico[TAMANO]; 
    static char estatico[TAMANO]; 
    void * puntero; 

    puntero=(void *) malloc (TAMANO);
    printf ("parametro n:%d en %p\n",n,&n);
    printf ("valor puntero:%p en direccion: %p\n", puntero,&puntero);
    printf ("array estatico en:%p \n",estatico);
    printf ("array automatico en %p\n",automatico);
    if (liberar==ANTES)
        free (puntero);
    if (n>0)
       recursiva(n-1,liberar,delay);
    if (liberar==DESPUES)
       free (puntero);
    if (n==0 && delay)        /* espera para la ultima recursividad*/  
       sleep (delay);
}

int comm_rec(char ** trozos){
    int tam=0;
    while(trozos[tam]!=NULL) tam++;
    if ((tam==1) || (tam>4)) {printf("Numero de parametros incorrectos.\n");return -1;}
    int i;
    int s=0;
    int liberar=1;
    for (i=1;i<tam-1;i++){
        if ((strcmp(trozos[i],"-a"))==0) liberar = -1;
        else if ((strcmp(trozos[i],"-n"))==0) liberar = 0;
        else if ((strcmp(trozos[i],"-d"))==0) liberar = 1;
        else if ((strncmp(trozos[i],"-s",2))==0) s = strtol(trozos[i]+sizeof(char)*2, (char **)NULL, 10);
        else {printf("Parametros incorrectos.\n");return -1;}
    }
    int n = strtol(trozos[tam-1], (char **)NULL, 10);
    recursiva(n,liberar,s);
}
int imprime_shared_lista(){
	int i=0;
	while(i<shared_lista_size){
		if (shared_lista[i].pt!=NULL){
			printf("[%p]\tClave: %i\n",shared_lista[i].pt,shared_lista[i].clave);
		}
		i++;
	}
}
int shared_lista_add(int clave,void * p){
	int i=0;
	while (shared_lista[i].pt!=NULL) i++;
	if (i>=MAXARRAY) {printf("Array del registro de shmat lleno."); return -1;}
	if (i+1>shared_lista_size) shared_lista_size=i+1;
	shared_lista[i].clave = clave;
	shared_lista[i].pt = p;
	return 0;
}

int shared_lista_rm(void * dirmem){
	int i=0;
	while(i<shared_lista_size){
		if (shared_lista[i].pt==dirmem){
			if ((shmdt(shared_lista[i].pt))<0){
				perror("Error shmdt");
				return -1;
			} else {
				shared_lista[i].pt=NULL;
				while((shared_lista[shared_lista_size-1].pt==NULL) && (shared_lista_size>0)) shared_lista_size--;
				return 0;
			}
		}
		i++;
	}
	return 1;
}

int esta_en_shared_lista(void * dirmem){
	int i;
	for (i=0;i<shared_lista_size;i++){
		if (shared_lista[i].pt==dirmem) return 1;
	}
	return 0;
}

void * get_shmdir(char * arg){
	int i=0;
	if (strncmp(arg,"0x",2)==0) {
		void * dir = (void*)strtoul(arg,(char **)NULL,0);
		if (esta_en_shared_lista(dir)){
			return (void*)strtoul(arg,(char **)NULL,0);
		} else {printf("Error: clave no valida: direccion no mapeada.\n"); return NULL;}
	};
	int clave;
	if ((clave=strtol(arg,(char**)NULL,10))<=0){printf("Error: clave no valida.\n"); return NULL;}
	int shmid = shmget(clave, 0,SHM_MODOS);
	if (shmid<0){
		perror("Error shmid");
		return NULL;
	}
	void * p = shmat(shmid,NULL,0);
	if (p==((void *)-1)){
		perror("Error shmat");
		return NULL;
	}
	if ((shared_lista_add(clave,p))<0) return NULL;
	return p;
}

struct FICHERO{
	char nombre[MAXNOMBRE];
	int tamano;
	mode_t permisos;
	time_t fecha;
	int offset;
	int borrado;
};

struct FS{
	int libre;
	int tamano;
	int nficheros;
	int inodos_cont;
	mode_t modos;
	struct FICHERO inodo[MAXFICHEROS];
};

int init_fs(void * p,int tamano){
	struct FS * fs = malloc(sizeof(struct FS));
	fs->tamano = tamano;
	fs->libre = tamano - sizeof(struct FS);
	fs->nficheros = 0;
	fs->modos = SHM_MODOS;
	fs->inodos_cont = 0;
	int i;
	for (i=0;i<MAXFICHEROS;i++) fs->inodo[i].borrado = 1;
	memcpy(p,fs,sizeof(struct FS));
	return 0;
}

int comm_sharedcreat(char ** trozos){
	int inicializar = 1;
	if (trozos[2]==NULL) {printf("Numero de parametros incorrectos.\n");return -1;}
	int clave = strtol(trozos[1],(char **)NULL,10);
	int tamano = strtol(trozos[2],(char **)NULL,10);
	if (tamano<=sizeof(struct FS)) {printf("Error: tamano minimo para crear un FS: %i Bytes.\n",sizeof(struct FS))+1;return -1;}
	if ((clave<0) || (tamano<0)) {printf("Parametros incorrectos.\n");return -1;}
	int shmid = shmget(clave, tamano, IPC_CREAT | IPC_EXCL | SHM_MODOS);
	if (shmid<0){
		if (errno==EEXIST){
			printf("La zona de memoria ya existia con anterioridad.\n");
			inicializar = 0;
			if ((shmid = shmget(clave, tamano, IPC_CREAT | SHM_MODOS))<0){
				perror("Error shmid");
				return -1;
			}
		}
		else{
			perror("Error shmid");
			return -1;
		}
	}
	void * p = shmat(shmid,NULL,0);
	if (p==((void *)-1)){
		perror("Error shmat");
		return -1;
	}
	if ((shared_lista_add(clave,p))<0) return -1;
	printf("Se ha mapeado en %p.\n",p);
	if (inicializar==1) init_fs(p,tamano);
}

int comm_shareddel(char ** trozos){
	if (trozos[1]==NULL) {printf("Numero de parametros incorrectos.\n");return -1;}
	int clave = strtol(trozos[1],(char **)NULL,10);
	int shmid;
	if ((shmid = shmget(clave, 0,SHM_MODOS))<0) {perror("Error shmid"); return -1;}
	struct shmid_ds buf;
	if ((shmctl(shmid,IPC_RMID,&buf))<0){perror("Error shmctl"); return -1;}
}

int comm_sharedinfo(char ** trozos){
	if (trozos[1]==NULL) {printf("Numero de parametros incorrectos.\n");return -1;}
	char * clave = trozos[1];
	void * p = get_shmdir(clave);
	if (p==NULL) {perror("Error shared-info"); return -1;}
	struct FS * fs = (struct FS *) p;
	if (fs==NULL) {perror("Error shared-info"); return -1;}
	printf("Tamano de la memoria: %i Bytes\n",fs->tamano);
	printf("Libre: %i Bytes\n",fs->libre);
	printf("No de ficheros: %i\n",fs->nficheros);
	int i;
	printf("FICHEROS:\n");
	for (i=0;i<fs->inodos_cont;i++){
		if (fs->inodo[i].borrado==0){
			char * ult_acceso = (char *)ctime(&fs->inodo[i].fecha);
			printf("%s\t%i\t%.*s\t\%s\n",devolver_permisos(fs->inodo[i].permisos)
										,fs->inodo[i].tamano
										,strlen(ult_acceso)-1,ult_acceso,fs->inodo[i].nombre);
		}
	}
	if (i==0) printf("(vacio)\n");
}


int copiar(char * clave1, char * fich1, char * clave2, char * fich2){
	void * dirmem;
	int tamano;
	int permisos;
	// Fuente disco
	if (clave1==NULL){
		if ((dirmem = fun_read((void*)0,fich1))==(void *)-1){perror("Error fun_read");return -1;}		
		struct stat buf;
		if ((stat(fich1,&buf))<0){perror("Error stat");return -1;}
		tamano = buf.st_size;
		permisos = buf.st_mode;
	}
	// Fuente memoria
	else{
		struct FS * fs = (struct FS *)get_shmdir(clave1);
		if (fs==NULL) {return -1;}
		int i=0;
		while (i<fs->inodos_cont){
			if ((strcmp(fs->inodo[i].nombre,fich1))==0) break;
			i++;
		}
		if (i<fs->inodos_cont){
			tamano = fs->inodo[i].tamano;
			dirmem = (void*)fs + fs->inodo[i].offset;
			permisos = fs->inodo[i].permisos;
			fs->inodo[i].fecha = time(NULL);
		} else {printf("Error: no existe el fichero fuente.\n"); return -1;}
	}	
	// Destino disco
	if (clave2==NULL){
		if ((fun_write(dirmem,fich2,tamano,0,permisos))<0){perror("Error fun_write");return -1;}	
	}
	// Destino memoria
	else{
		struct FS * fs = (struct FS *)get_shmdir(clave2);
		if (fs==NULL) {return -1;}
		int i=0;
		while (i<fs->inodos_cont){
			if (((strcmp(fs->inodo[i].nombre,fich2))==0) && (fs->inodo[i].borrado==0)){
				printf("Error: ya existe un archivo en memoria con ese nombre.\n");
				return -1;
				
			}
			i++;
		}
		i=0;
		if (tamano>fs->libre) {printf("Error: no hay espacio suficiente.\n"); return -1;}
		while(fs->inodo[i].borrado == 0) i++;
		if ((i+1)==MAXFICHEROS) {printf("Error: alcanzado limite de ficheros.\n"); return -1;}
		fs->inodo[i].tamano = tamano;
		strcpy(fs->inodo[i].nombre,fich2);
		fs->inodo[i].fecha = time(NULL);
		fs->inodo[i].borrado=0;
		fs->inodo[i].permisos = permisos;
		fs->inodo[i].offset = fs->tamano - fs->libre;
		fs->libre = fs->libre - tamano;
		memcpy((void*)fs+(fs->inodo[i].offset),dirmem,tamano);
		fs->nficheros++;
		if (fs->nficheros > fs->inodos_cont) fs->inodos_cont = fs->nficheros;
	}
	return 0;
}

int comm_sharedcp(char ** trozos){
	char * clave1 = NULL;
	char * clave2 = NULL;
	char * fich1;
	char * fich2;
	if (trozos[2]==NULL) {printf("Error: numero de parametros incorrectos.\n");return -1;}
	char arg1[strlen(trozos[1])];
	char arg2[strlen(trozos[2])];
	strcpy(arg1,trozos[1]);
	strcpy(arg2,trozos[2]);
	char ** a = trocear(arg1,"\\:");
	if (a[1]==NULL) fich1 = a[0];
	else {
		clave1=a[0];
		fich1 = a[1];
	}
	a = trocear(arg2,"\\:");
	if (a[1]==NULL) fich2 = a[0];
	else {
		clave2=a[0];
		fich2 = a[1];
	}
	return copiar(clave1,fich1,clave2,fich2);
}

int shm_fich_rm(char * clave,char * fich){
	struct FS * fs = (struct FS *)get_shmdir(clave);
	if (fs==NULL) {perror("Error get_shmdir"); return -1;}
	int i=0;
	while (i<fs->inodos_cont){
		if (((strcmp(fs->inodo[i].nombre,fich))==0) && (fs->inodo[i].borrado==0))
			break;
		i++;
	}
	if (i==fs->inodos_cont){printf("Error: no existe el fichero.\n"); return -1;}
	fs->inodo[i].borrado=1;
	if (i==fs->inodos_cont-1) fs->inodos_cont--;
	fs->nficheros--;
	fs->libre = fs->libre + fs->inodo[i].tamano;
	int offset = fs->inodo[i].offset;
	int despl = fs->inodo[i].tamano;
	i++;
	while(i < fs->inodos_cont){
		fs->inodo[i].offset = fs->inodo[i].offset - despl;
		i++;
	}
	memmove((void*)fs+offset,(void*)fs+despl+offset,fs->tamano -offset -fs->libre);
	
}

int comm_sharedrm(char * arg){
	char * clave1 = NULL;
	char * fich1;
	char ** a1 = trocear(arg,"\\:");
	if (a1[1]==NULL) fich1 = a1[0];
	else {
		clave1 = a1[0];
		fich1 = a1[1];
	}
	if (clave1==NULL){
		if ((remove(fich1))<0) {perror("Error remove"); return -1;}
	}
	else shm_fich_rm(clave1,fich1); 
}

int comm_detach(char ** trozos){
	int forzar = 0;
	void * dirmem;
	if (trozos[1]==NULL) {imprime_shared_lista(); return 0;}
	if (trozos[2]==NULL) dirmem = (void *)strtoul(trozos[1],(char **)NULL,0);
	else if ((strcmp(trozos[1],"-f"))==0){
		forzar = 1;
		dirmem = (void *)strtoul(trozos[2],(char **)NULL,0);
	} else {printf("Error: parametros incorrectos.\n");return -1;}
	if ((shared_lista_rm(dirmem))==1){
		if (forzar==1){
			if ((shmdt(dirmem))<0){
				perror("Error shmdt");
				return -1;
			}
		} else printf("No representa una dirección obtenida mediante shmat. -f para forzar.\n");	
	}
}

int comm_direcciones(char ** trozos){
	if ((trozos[1]==NULL) || ((strcmp(trozos[1],"-p"))==0)){
		printf("shmat:\n");
		imprime_shared_lista();
		printf("mmap:\n");
		imprime_mmap_lista();
		printf("malloc:\n");
		imprime_malloc_lista();
		return 0;
	}
	if ((strcmp(trozos[1],"-v"))==0){
		printf("Variables globales:\n");
		printf("\tmalloc_lista = %p\n",&malloc_lista);
		printf("\tmalloc_lista_size = %p\n",&malloc_lista_size);
		printf("\tshared_lista = %p\n",&shared_lista);
		printf("\tshared_lista_size = %p\n",&shared_lista_size);
		printf("\tmmap_lista = %p\n",&mmap_lista);
		printf("\tmmap_lista_size = %p\n",&mmap_lista_size);
		printf("\tdireccion_entrada = %p\n",&direccion_entrada);
		printf("\tdireccion_trozos = %p\n",&direccion_trozos);
		printf("\tprompt = %p\n",&prompt);
		printf("Variables main:\n");
		printf("\tentrada = %p\n",direccion_entrada);
		printf("\ttrozos = %p\n",direccion_trozos);
		printf("Funciones del programa llamadas desde main:\n");
		printf("\ttrocear = %p\n",&trocear);
		printf("\tprocesar = %p\n",&procesar);
		return 0;
	}
	printf("Parametros incorrectos.\n");
}

int list_char_add(char ** lista,char * elem){
	int i=0;
	char *p;
	if (lista==NULL)
		return -1;
	while ((lista[i]!=NULL) && (i<MAXLISTA-1)){
   		if (!strcmp(lista[i],elem))
   			return -2;
   		else
   			i++;
   	}
    if ((i==MAXLISTA-1) || ((p=strdup(elem))==NULL))
    	return -1;
    lista[i]=p;
    lista[i+1]=NULL;
    return 0;
}

int list_char_pos(char ** lista,char *elem){
	int i=0;
	while (lista[i]!=NULL){
		if (!strcmp (lista[i],elem))
			return i;
		else i++;
	}
	return -1;
}
  
int list_char_del(char ** lista,char *elem){
	int pos;
	if ((pos=list_char_pos(rbl,elem))==-1)
		return -1;
	free(lista[pos]);
	while (lista[pos]!=NULL){
		lista[pos]=lista[pos+1];
		pos++;
  	}
  	return 0;
}

int list_char_vaciar(char ** lista){
	int i=0;
	while (lista[i]!=NULL){
		free(lista[i]);
		lista[i]=NULL;
		i++;
  	}
  	return 0;
}

int list_char_print(char ** lista){
	int i=0;
	while (lista[i]!=NULL){
		printf("%s\n",lista[i]);
		i++;
	}
}

int list_proc_add(struct myproc * lista, struct myproc elem){
	int i=0;
	struct myproc p;
	if (lista==NULL)
		return -1;
	while ((lista[i].comando!=NULL) && (i<MAXLISTA-1)){
   		if (lista[i].pid==elem.pid)
   			return -2;
   		else
   			i++;
   	}
    if (i==MAXLISTA-1)
    	return -1;
    lista[i]=elem;
    lista[i+1].comando=NULL;
    return 0;
}

int list_proc_pos(struct myproc * lista, struct myproc elem){
	int i=0;
	while (lista[i].comando!=NULL){
		if (lista[i].pid==elem.pid)
			return i;
		else i++;
	}
	return -1;
}
  
int list_proc_del(struct myproc * lista, struct myproc elem){
	int pos;
	if ((pos=list_proc_pos(lista,elem))==-1)
		return -1;
		lista[pos].comando==NULL;
	while (lista[pos].comando!=NULL){
		lista[pos]=lista[pos+1];
		pos++;
  	}
  	return 0;
}

int list_proc_vaciar(struct myproc * lista){
	int i=0;
	while (lista[i].comando!=NULL){
		lista[i].comando=NULL;
		i++;
  	}
  	return 0;
}
int mygetpriority(pid_t pid){
	errno = 0;
	int prio;
	prio = getpriority(PRIO_PROCESS,pid);
	if (errno==0)
		return prio;
	else return GETPRIOERROR;
}
int actualizar_proc(struct myproc * elem){
	int prio;
	if ((prio=mygetpriority(elem->pid))!=GETPRIOERROR) elem->prio=prio;
	if (elem->terminado==0){
		int estado;
		if (waitpid(elem->pid,&estado,WNOHANG | WUNTRACED | WCONTINUED)>0){
			if (WIFEXITED(estado)) elem->strestado = "EXITED";
			else if (WIFSIGNALED(estado)) elem->strestado = "SIGNALED";
			else if (WIFSTOPPED(estado)) elem->strestado = "STOPPED";
			else if (WIFSTOPPED(elem->estado)) elem->strestado = "ACTIVE";
			elem->estado=estado;
		}
	}
	return 0;
}

int print_line_proc(struct myproc * elem){
	char * inicio = ctime(&(elem->inicio));
	if (!strcmp(elem->strestado,"ACTIVE"))
		printf("%i\t%s\t\t\t\t\t%i\t%.*s\t%s\n",elem->pid, elem->strestado, elem->prio,strlen(inicio)-1,inicio, elem->comando );
	else if (!strcmp(elem->strestado,"EXITED"))
		printf("%i\t%s(%i)\t\t\t\t%i\t%.*s\t%s\n",elem->pid, elem->strestado,WEXITSTATUS(elem->estado), elem->prio,strlen(inicio)-1,inicio, elem->comando );
	else if (!strcmp(elem->strestado,"SIGNALED"))
		printf("%i\t%s(%i): %*.*s\t%i\t%.*s\t%s\n",elem->pid, elem->strestado,WTERMSIG(elem->estado),25,25, strsignal(WTERMSIG(elem->estado)), elem->prio,strlen(inicio)-1,inicio, elem->comando );
	else if (!strcmp(elem->strestado,"STOPPED"))
		printf("%i\t%s(%i): %*.*s\t%i\t%.*s\t%s\n",elem->pid, elem->strestado,WSTOPSIG(elem->estado),25,25, strsignal(WSTOPSIG(elem->estado)),elem->prio,strlen(inicio)-1,inicio, elem->comando );
	return 0;
}

int list_proc_access_by_state(struct myproc * lista, char ** param,int modo) {
	int i=0;
	struct myproc * p;
	while (lista[i].comando!=NULL){
		actualizar_proc(&lista[i]);
		if ((modo==IMPRIME_ALL)
		|| ((!strcmp(lista[i].strestado,"ACTIVE")) && (list_char_pos(param,"-a")>=0))
		|| ((!strcmp(lista[i].strestado,"EXITED")) && (list_char_pos(param,"-n")>=0))
		|| ((!strcmp(lista[i].strestado,"SIGNALED")) && (list_char_pos(param,"-s")>=0))
		|| ((!strcmp(lista[i].strestado,"STOPPED")) && (list_char_pos(param,"-p")>=0))){
			if ((modo==IMPRIME_ALL) || (modo==IMPRIMIR))
				print_line_proc(&lista[i]);
			else{
				list_proc_del(lista,lista[i]);
				i--;
			}
		}
		i++;
	}
}


int list_proc_access_by_pid(struct myproc * lista, char ** pids,int modo) {
	int i=0;
	int j=0;
	while (lista[i].comando!=NULL){
		j=0;
		while (pids[j]!=NULL){
			if (lista[i].pid==strtol(pids[j],(char **)NULL,10)) {
				actualizar_proc(&lista[i]);
				if (modo==IMPRIMIR)
					print_line_proc(&lista[i]);
				else {
					list_proc_del(lista,lista[i]);
					i--;
				}
				break;
			}
		j++;
		}
	i++;
	}
}

char * mywhich(char * xpath){
    static char p[MAXARRAY];
    struct stat buf;
  
    if (xpath==NULL)
    	return NULL;
	if ((!strncmp(xpath,"/",1)) || (!strncmp(xpath,"./",2)) || (!strncmp(xpath,"../",3))){
		if ((stat(xpath,&buf))<0) return NULL;
		else return xpath;
	}
	int i=0;
	while(rbl[i]!=NULL){
		strcpy(p,rbl[i]);
		strcat(p,"/");
		strcat(p,xpath);
		if ((stat(p,&buf))>=0) return p;
		i++;
	}
	return NULL;	
}




int getvarenv(char * var, char ** entorno){
	int i=0;
	char * varenv;
	char aux[MAXLINEA];
	strcpy(aux,var);
	strcat(aux,"=");
	if (entorno==(char **)NULL) return -1;
	while(entorno[i]!=NULL){
		if (!strncmp(aux,entorno[i],strlen(aux))) 
			return i;
		i++;
	}
	return -1;
}

int print_env(char ** varv, char ** entorno){
	int i = 0;
	int pos;
	char *var;
	if (varv!=(char **)NULL){
		while(varv[i]!=NULL){
			if ((pos=getvarenv(varv[i],environ))!=-1)
				printf("%p->environ[%d] = (%p) %s\n",&environ[pos],pos,environ[pos],environ[pos]);
			if ((pos=getvarenv(varv[i],envmain))!=-1)
				printf("%p->env[%d] = (%p) %s\n",&envmain[pos],pos,envmain[pos],envmain[pos]);
			if ((var=getenv(varv[i]))!=NULL)
				printf("getenv -> (%p) %s\n",var,var);
			i++;
		}
	}
	else{
		while(entorno[i]!=NULL){
			printf("%p->env[%d] = (%p) %s\n",&entorno[i],i,entorno[i],entorno[i]);
			i++;
		}
	}
	return 0;
}

int put_env(char * var, char * valor, char ** entorno, int modo){
	int pos;
	char * aux = malloc(sizeof(char)*(strlen(var)+strlen(valor)+2));
	if (modo==PUT){
		strcpy(aux,var);
		strcat(aux,"=");
		strcat(aux,valor);
	}
	else //modo==SUS
		strcpy(aux,valor);
	if (entorno==(char **)NULL){
		return putenv(aux);
	}
	else {
		if ((pos=getvarenv(var,entorno))==-1) return -2;
		entorno[pos]=aux;
	}
	return 0;
}

int validarvar(char * var){
	int igual = (int)'=';
	char * index = strchr(var,igual);
	if ((index==NULL) || (index==var)) return 0;
	else return 1;
}

char * getcomando(char ** entrada){
	if ((entrada[0]!=NULL) && (entrada[0][0]=='@')){
		entrada++;
	}
	if ((entrada[0]!=NULL) && (!strcmp(entrada[0],"ENTORNOVACIO"))) entrada++;
	else while((entrada[0]!=NULL) && ((validarvar(entrada[0])) || (getvarenv(entrada[0],environ)>=0))) entrada++;
	char * p = mywhich(entrada[0]);
	if (p==NULL) {
		return NULL;
	}
	int i=0;
	char comando[MAXNOMBRE];
	strcpy(comando,"");
	while (entrada[i]!=NULL){
		strcat(comando,entrada[i]);
		strcat(comando," ");
		i++;
	}
	return strdup(comando);
}

int comm_jobs(char ** trozos, int modo){
	if (trozos[1]==NULL) {
		list_proc_access_by_state(spl,(char **)NULL,IMPRIME_ALL);
		return 0;
	}
	if ((!strcmp(trozos[1],"-n")) || (!strcmp(trozos[1],"-s")) || (!strcmp(trozos[1],"-p")) || (!strcmp(trozos[1],"-a")))  { 
		list_proc_access_by_state(spl,trozos++,modo);
		return 0;
	}
	list_proc_access_by_pid(spl,trozos++,modo);
}


int comm_path(char ** trozos){
	if (trozos[1]==NULL) list_char_print(rbl);
	else if (!strcmp(trozos[1],"-p")){
		if (getenv("PATH")==NULL) return 0;
		char ** path_env = trocear(strdup(getenv("PATH")),":");
		int i=0;
		while(path_env[i]!=NULL){
			list_char_add(rbl,path_env[i]);
			i++;
		}
	}
	else if (!strcmp(trozos[1],"-n")){
		list_char_vaciar(rbl);
	}
	else if (trozos[2]==NULL){
		printf("Parametros incorrectos.\n");
		return -1;
	}
	else if ((!strcmp((&trozos[2][strlen(trozos[2])-1]),"/")) && (strlen(trozos[2])!=1)) {
		printf("Directorio no valido.\n");
		return -1;
	}
	else if (!strcmp(trozos[1],"-q")){
		if (list_char_pos(rbl,trozos[2])<0) printf("No esta en la ruta de busqueda.\n");
		else printf("Esta en la ruta de busqueda.\n");
	}
	else if (!strcmp(trozos[1],"-d")){
		if (list_char_del(rbl,trozos[2])==-1) printf("No esta en la ruta de busqueda.\n");
	}
	else if (!strcmp(trozos[1],"-a")){
		int estado;
		if ((estado=list_char_add(rbl,trozos[2]))<0){
			if (estado==-1) printf("Error: ruta de busqueda llena.\n");
			else if (estado==-2) printf("Error: ya estaba en la ruta de busqueda.\n");
			return -1;
		}
	}
	else if (!strcmp(trozos[1],"-f")){
		char * p = mywhich(trozos[2]);
		if (p==NULL) printf("%s : no existe.\n",trozos[2]);
		else printf("%s\n",p);
	}
	else {
		printf("Parametros incorrectos.\n");
		return -1;
	} 
	return 0;
}

int redireccion(int desc, char * fich){
	int df;
	int flags = O_RDWR | O_CREAT;
	if (desc == STDIN_FILENO)
		flags = O_RDONLY;
	if ((df = open(fich,flags,0700))==-1)
		return -1;
	close(desc);
	dup(df);
	close(df);
	return 0;
}

void deshacer_redireccion(){
	close(STDIN_FILENO);
	dup(copiaEE);
	close(STDOUT_FILENO);
	dup(copiaSE);
	close(STDERR_FILENO);
	dup(copiaES);
}

int comm_exec(char ** trozos){
	int pri;
	while((trozos[0]!=NULL) && (trozos[1]!=NULL)){
		if (!strcmp(trozos[0],"redir-e")) redireccion(STDIN_FILENO,trozos[1]);
		else if (!strcmp(trozos[0],"redir-s")) redireccion(STDOUT_FILENO,trozos[1]);
		else if (!strcmp(trozos[0],"redir-r")) redireccion(STDERR_FILENO,trozos[1]);
		else break;
		trozos++; trozos++;
	}
	if ((trozos[0]!=NULL) && (trozos[0][0]=='@')){
		pri=atoi(trozos[0]+1);
		setpriority(PRIO_PROCESS,getpid(),pri);
		trozos++;
	}
	char * nuevoenv[MAXLISTA];
	nuevoenv[0] = NULL;
	int pos;
	int vacio = 0;
	if ((trozos[0]!=NULL) && (!strcmp(trozos[0],"ENTORNOVACIO"))){
		 vacio = 1;
		 trozos++;
	}
	else while(trozos[0]!=NULL){
		if (validarvar(trozos[0])) list_char_add(nuevoenv,trozos[0]);
		else if ((pos=getvarenv(trozos[0],environ))>=0) list_char_add(nuevoenv,environ[pos]);
		else break;
		trozos++;
	}
	char * p = mywhich(trozos[0]);
	if (p==NULL) printf("Ejecutable no encontrado \n");
	else if (vacio){
		if (execve(p,trozos,(char **)NULL)<0) 
			perror("Error execve");
	}
	else if (nuevoenv[0]==NULL){
		if (execv(p,trozos)<0) 
			perror("Error execv");
	}
	else {
		if (execve(p,trozos,nuevoenv)<0) 
			perror("Error execve");
	}
	deshacer_redireccion();
	return -1; 
}

int comm_com(char ** trozos) {
	pid_t pid;
	int back=0;
	int i=0;
	while (trozos[i]!=NULL){
		if (!strcmp(trozos[i],"&")){
			back=1;
			trozos[i]=NULL;
			break;
		}
		i++;
	}
	if ((pid=fork())==0){
		comm_exec(trozos);
		exit(0);
	}
	if (!back)
		waitpid(pid,NULL,0);
	else {
		struct myproc proc;
		if ((proc.comando=getcomando(trozos))==NULL) return -1;
		proc.inicio=time(NULL);
		proc.terminado=0;
		proc.prio=mygetpriority(pid);
		proc.strestado="ACTIVE";
		proc.pid=pid;
		actualizar_proc(&proc);
		list_proc_add(spl,proc);
	}
}

int comm_getpriority(char ** trozos){
	pid_t pid;
	if (trozos[1]==NULL) pid=getpid();
	else pid = strtol(trozos[1],(char **)NULL,10);
	int prio;
	if ((prio=mygetpriority(pid))==GETPRIOERROR){
		perror("Error getpriority");
		return -1;
	}
	printf("Prioridad de %i: %i\n",pid,prio);
}

int comm_setpriority(char ** trozos){
	pid_t pid;
	int pri;
	if (trozos[1]==NULL){
		printf("Error: parametros insuficientes.\n");
		return -1;
	}
	if (trozos[2]==NULL) {
		pid=getpid();
		pri=strtol(trozos[1],(char **)NULL,10);
	}
	else {
		pid = strtol(trozos[1],(char **)NULL,10);
		pri = strtol(trozos[2],(char **)NULL,10);
	}
	if ((setpriority(PRIO_PROCESS,pid,pri))<0){
		perror("Error setpriority");
		return -1;
	}
	printf("Prioridad de %i se ha establecido a %i\n",pid,pri);
}


int comm_putenv(char ** trozos, int modo){
	char ** entorno;
	int ret;
	if ((trozos[1]==NULL) || (trozos[2]==NULL) || (trozos[3]==NULL)) 
		{printf("Parametros insuficientes\n"); return -1;}
	if (!strcmp(trozos[1],"-m")) entorno = envmain;
	else if (!strcmp(trozos[1],"-e")) entorno = environ;
	else if ((!strcmp(trozos[1],"-p")) && (modo == PUT)) entorno = (char **)NULL;
	else {printf("Parametros incorrectos\n"); return -1;}
	if (modo==PUT) 
		ret=put_env(trozos[2],trozos[3],entorno,modo);
	else // modo == SUS
		if (!validarvar(trozos[3])) {printf("Nueva variable invalida.\n"); return -1;}
		ret=put_env(trozos[2],trozos[3],entorno,modo);
	if (ret==-2) printf("La variable no existe.\n");
	else if (ret==-1) perror("Error putenv");
	return 0;		
}

int comm_entorno(char ** trozos){
	if (trozos[1]==NULL) {printf("Parametros insuficientes\n"); return -1;}
	if (!strcmp(trozos[1],"-m")) print_env((char**)NULL,envmain);
	else if (!strcmp(trozos[1],"-e")) print_env((char**)NULL,environ);
	else {printf("Parametros incorrectos\n"); return -1;}
}

int comm_entornos(char ** trozos){
	printf("%p->environ=%p | %p->env=%p\n",&environ,environ,&envmain,envmain);
	return 0;
}

int comm_get(char ** trozos){
	trozos++;
	print_env(trozos,(char **)NULL);
}

int comm_creds(){
	printf("Real de usuario: %s (%i)\n",getpwuid(getuid())->pw_name,getuid());
	printf("Efectiva de usuario: %s (%i)\n",getpwuid(geteuid())->pw_name,geteuid());
	printf("Real de grupo: %s (%i)\n",getgrgid(getgid())->gr_name,getgid());
	printf("Efectiva de grupo: %s (%i)\n",getgrgid(getegid())->gr_name,getegid());
}

int comm_setuid(char ** trozos){
	if (trozos[1]==NULL) {printf("Parametros insuficientes\n"); return -1;}
	if (trozos[2]==NULL){
		if (setuid(strtol(trozos[1],(char **)NULL,10))<0){
			perror("Error setuid");
			return -1;
		}
	}
	else if (strcmp(trozos[1],"-l")) {printf("Parametros incorrectos\n"); return -1;} 
	else {
		struct passwd * p = getpwnam(trozos[2]);
		if (p==NULL) {
			perror("Error getpwnam");
			return -1;
		}
		if (setuid(p->pw_uid)){
			perror("Error setuid");
			return -1;
		}
	}
	return 0;
}

int comm_pipe(char ** trozos){
	int df[2];
	int p1,p2;
	int i=0;
	while ((trozos[i]!=NULL) && (strcmp(trozos[i],"%")!=0)) i++;
	if ((i<=1) || (trozos[i]==NULL) || (trozos[i+1]==NULL)) {printf("Parametros invalidos.\n"); return -1;}
	trozos[i] = NULL;
	pipe(df);
	if ((p1=fork())==0){
		close(1);
		dup(df[1]);
		comm_exec(++trozos);
		exit(-1);
	}
	if ((p2=fork())==0){
		close(df[1]);
		close(0);
		dup(df[0]);
		while(trozos[0]!=NULL) trozos++;
		comm_exec(++trozos);
		exit(-1);
	}
	close(df[1]); close(df[0]);
	waitpid(p1,NULL,0);
	waitpid(p2,NULL,0);
}

int cargar_fichero(char * fich){
	FILE * fd;
	if ((fd=fopen(fich,"r"))==NULL) {printf("No se puede abrir %s.\n",fich); return -1;}
	char entrada[MAXLINEA];
	while(fgets(entrada,MAXLINEA,fd)!=NULL) procesar(trocear(entrada," \n\t"));
	return 0;
}

int main(int argc, char * argv[], char *env[]){
	copiaEE = dup(STDIN_FILENO);
	copiaSE = dup(STDOUT_FILENO);
	copiaES = dup(STDERR_FILENO);
	malloc_lista_size=0;
	mmap_lista_size=0;
	shared_lista_size=0;
	envmain = env;
	char entrada[MAXLINEA];
	char ** trozos;
	direccion_entrada=&entrada;
	direccion_trozos=&trozos;
	if (argc>1) cargar_fichero(argv[1]);
	while(1) {
		printf(prompt);
		if (fgets(entrada,MAXLINEA,stdin)==NULL) return 1;
		trozos=trocear(entrada," \n\t");
        procesar(trozos);
	}
	return 0;
}

