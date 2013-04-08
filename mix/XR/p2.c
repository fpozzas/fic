// PRACTICA 2: Servidor TCP

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h> 
#include <arpa/inet.h>
#include <stdio.h>
#include <string.h>
#include <netdb.h>


int main(int argc, char * argv[]){
    if (argc<2) {
        printf("Sintaxis: servidorTCP <puerto>\n");
        return -1;
    }
    
    int socketfd = socket(AF_INET,SOCK_STREAM,0);
    if (socketfd<0) {
        perror("Error al crear socket");
        return -1;
    }
    
    struct sockaddr_in addrlocal;
    addrlocal.sin_family = AF_INET;
    addrlocal.sin_addr.s_addr = htonl(INADDR_ANY);
    addrlocal.sin_port = htons(strtol(argv[1],(char **)NULL,10));
     
    
    if ((bind(socketfd,(struct sockaddr *)&addrlocal,sizeof(addrlocal)))<0) {
        perror("Error al hacer bind");
        return -1;
    }
    
    if ((listen(socketfd,10))<0) { perror("Listen"); return -1 ;}
    
    struct sockaddr_in remote_addr;
    socklen_t addrlen = sizeof (struct sockaddr);
    int new_socketfd;
    if ((new_socketfd=accept(socketfd,(struct sockaddr *)&remote_addr,&addrlen))<1) { perror("Accept"); return -1 ;}
    
while(1){
    char * buf = calloc(256,sizeof(char));
    recv(new_socketfd,buf,sizeof(buf),0);
    
    //printf("%s\n",buf);
    
    send(new_socketfd,buf,strlen(buf)+1,0);
    free(buf);
    }

    
     
}

