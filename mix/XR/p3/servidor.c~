// PRACTICA 2: Servidor TCP

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h> 
#include <arpa/inet.h>
#include <stdio.h>
#include <string.h>
#include <netdb.h>
#include <stdlib.h>
#include "structs.h"

// Funcion trocear (para manejar las lineas del fichero
char **trocear(char * entrada, char * s) {
	static char * tok[20];
	tok[0]=strtok(entrada,s);
	int i=1;
	while((tok[i]=strtok(NULL,s))!=NULL) i++;
	return tok;
}



int main(int argc, char * argv[]){
    
    // Cargamos las opciones
    FILE * fich;
  	if ((fich = fopen("configuracion.txt", "r")) == NULL){ printf("Error al abrir el fichero configuracion.txt\n"); return -1 ;}
    char linea[20];
    int i = 0;
	int puerto = 0;
	int intentos = 0;
	char ** trozos;
    for(i=0;i<2;i++){
		if (fgets(linea,20,fich)==NULL){printf("Error al leer el fichero configuracion.txt\n"); return -1 ;}
		trozos=trocear(linea," ");
		if ((trozos[0]==NULL) || (trozos[1]==NULL)) {printf("Error al leer el fichero configuracion.txt\n"); return -1 ;}
		if (!strcmp(trozos[0],"port")) puerto = strtol(trozos[1],(char **)NULL,10);
		else if (!strcmp(trozos[0],"maxAttempts")) intentos = strtol(trozos[1],(char **)NULL,10);
    }
    if ((puerto==0)||(intentos==0)) {printf("Error, opciones incorrectas\n"); return -1 ;}
	printf("Puerto: %i\nIntentos: %i\n",puerto,intentos);
	fclose(fich);
    // Hacemos las conexiones
    
    int socketfd = socket(AF_INET,SOCK_STREAM,0);
    if (socketfd<0) {
        perror("Error al crear socket");
        return -1;
    }
    struct sockaddr_in addrlocal;
    addrlocal.sin_family = AF_INET;
    addrlocal.sin_addr.s_addr = htonl(INADDR_ANY);
    addrlocal.sin_port = htons(puerto);
     
    
    if ((bind(socketfd,(struct sockaddr *)&addrlocal,sizeof(addrlocal)))<0) {
        perror("Error al hacer bind");
        return -1;
    }
    
    if ((listen(socketfd,10))<0) { perror("Listen"); return -1 ;}
    
    struct sockaddr_in remote_addr;
    socklen_t addrlen = sizeof (struct sockaddr);
    int new_socketfd;
    // Bucle de espera
    while(1){
    	if ((new_socketfd=accept(socketfd,(struct sockaddr *)&remote_addr,&addrlen))<1) 
    		{ perror("Error accept"); return -1 ;}
    	else if (fork()==0) break;
    	random();
    }
    
    // Bucle de iteracion con el cliente
    int numero = random()%100;
    printf("Inicio partida con cliente %i, solucion: %i\n",new_socketfd,numero);
	while(1){
		void * buf = malloc(sizeof(struct juego));
    	int r = recv(new_socketfd,buf,sizeof(struct juego),0);
    	if (r<-1) {perror("Error recv"); return -1;}
    	if (r==0) {printf("Error recv: cierre anomalo desde el cliente\n"); return -1;}
    	struct juego * jrecv = buf;
    	struct juego * jsend = malloc(sizeof(struct juego));
		if (jrecv==NULL) {printf("Recepción no valida.\n");close(new_socketfd); return -1;}
    	if (jrecv->operacion!=1) {printf("Código de operación recibido inválido.\n");close(new_socketfd); return -1;}
    	intentos--;
    	printf("Cliente %i dice: %i; solucion: %i; intentos restantes: %i\n",new_socketfd,jrecv->dato,numero,intentos);
    	jsend->operacion = 2;
    	if (intentos==0) jsend->dato = -2;
    	else if (jrecv->dato > numero) jsend->dato = 1; 
    	else if (jrecv->dato < numero) jsend->dato = -1; 
    	else if (jrecv->dato == numero) jsend->dato = 0; 
		int s;
    	if (s=send(new_socketfd,jsend,sizeof(struct juego),0)<0) {perror("Error send"); return -1;}
	   	if (jsend->dato==0) {printf("El cliente %i ha ganado!\n",new_socketfd);close(new_socketfd); return 0;}
	   	else if (intentos==0){printf("El cliente %i ha perdido!\n",new_socketfd); close(new_socketfd); return 0;}
    	free(buf);
    } 
}

