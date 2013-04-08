/*
AUTOR:font alonso, juan:infjfa00
AUTOR:fernandez nunez, daniel:infjfa00
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

#define MAXLINEA 1024
#define MAXARRAY 1000
#define LINEA 25
#define MAXNOMBRE 256
#define MAXFICHEROS 100
#define SHM_MODOS 00755

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
	else printf("Comando invalido.\n");
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
    wait();
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


int main(int argc, char * argv[]){
	malloc_lista_size=0;
	mmap_lista_size=0;
	shared_lista_size=0;

	char entrada[MAXLINEA];
	char ** trozos;
	direccion_entrada=&entrada;
	direccion_trozos=&trozos;
	while(1) {
		printf(prompt);
		fgets(entrada,MAXLINEA,stdin);
		trozos=trocear(entrada," \n\t");
        procesar(trozos);
	}
	return 0;
}

