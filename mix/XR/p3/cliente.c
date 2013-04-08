// PRACTICA 1: Cliente TCP

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h> 
#include <arpa/inet.h>
#include <stdio.h>
#include <string.h>
#include <netdb.h>
#include <stdlib.h>
#include "structs.h"

#define DIRSERVIDOR "127.0.0.1"

int main(int argc, char * argv[]){
    if (argc<2) {
        printf("Sintaxis: clienteTCP <puerto>\n");
        return -1;
    }
    
    // Creamos las conexiones
    int socketfd = socket(AF_INET,SOCK_STREAM,0);
    if (socketfd<0) {
        perror("Error al crear socket");
        return -1;
    }
    
    struct sockaddr_in addrlocal;
    addrlocal.sin_family = AF_INET;
    addrlocal.sin_addr.s_addr = htonl(INADDR_ANY);
    addrlocal.sin_port = htons(0);
     
    
    if ((bind(socketfd,(struct sockaddr *)&addrlocal,sizeof(addrlocal)))<0) {
        perror("Error al hacer bind");
        return -1;
    }
    struct sockaddr_in addrremote;
    addrremote.sin_family = AF_INET;
    addrremote.sin_addr.s_addr = inet_addr(DIRSERVIDOR);
    addrremote.sin_port = htons(strtol(argv[1],(char **)NULL,10));
    if ((connect(socketfd,(struct sockaddr *)&addrremote,sizeof(addrremote)))<0) {
        perror("Error al conectar");
        return -1;
    }
    
    // Bucle de interacion con el servidor
  	while(1){
  		// ENVIO
    	char entrada[5] = "\n";
    	while (!strcmp(entrada,"\n")){
    		printf("Dame un número entre 0 y 100:\n");
    		fgets(entrada,5,stdin);
    		}
   		struct juego * jsend = malloc(sizeof(struct juego));
    	jsend->operacion = 1;
    	jsend->dato = strtol(entrada,(char **)NULL,10);
    	int s;
    	if (send(socketfd,jsend,sizeof(struct juego),0)<0){perror("Error send"); return -1;}

  		// RECEPCION
    	void * buf = malloc(sizeof(struct juego));
    	int r = recv(socketfd,buf,sizeof(struct juego),0);
    	if (r<-1) {perror("Error recv"); return -1;}
    	if (r==0) {printf("Error recv: cierre anomalo desde el servidor\n"); return -1;}
    	struct juego * jrecv = buf;
    	if (jrecv==NULL) {printf("Recepción no valida.\n"); return -1;}
    	if (jrecv->operacion!=2) {printf("Código de operación recibido inválido.\n"); close(socketfd); return -1;}
    	if (jrecv->dato==-2) {printf("Número máximo de intentos alcanzado. Has perdido.\n"); close(socketfd); return 0;}
    	if (jrecv->dato==0) {
    		printf("Has ganado!\n"); 
    		close(socketfd);
    		return 0;
    	}
    	char estado[5];
    	if (jrecv->dato==1) strcpy(estado,"menor");
    	else if (jrecv->dato==-1) strcpy(estado,"mayor");
    	printf("El servidor dice que la solución es: %s\n",estado);
    	free(buf);
    } 
}

