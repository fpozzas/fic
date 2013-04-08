// PRACTICA 1: Cliente TCP

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h> 
#include <arpa/inet.h>
#include <stdio.h>
#include <string.h>
#include <netdb.h>


int main(int argc, char * argv[]){
    if (argc<4) {
        printf("Sintaxis: clienteTCP <nombre> <puerto> <mensaje>\n");
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
    addrlocal.sin_port = htons(0);
     
    
    if ((bind(socketfd,(struct sockaddr *)&addrlocal,sizeof(addrlocal)))<0) {
        perror("Error al hacer bind");
        return -1;
    }
    struct sockaddr_in addrremote;
    addrremote.sin_family = AF_INET;
    //struct hostent st_ip = *gethostbyname(argv[1]);
    addrremote.sin_addr.s_addr = inet_addr(argv[1]);
    addrremote.sin_port = htons(strtol(argv[2],(char **)NULL,10));
    //addrremote.sin_port = htons(atoi(argv[2]));
    if ((connect(socketfd,(struct sockaddr *)&addrremote,sizeof(addrremote)))<0) {
        perror("Error al conectar");
        return -1;
    }
    
    send(socketfd,argv[3],strlen(argv[3])+1,0);
    
    char buf[100];
    recv(socketfd,buf,100,0);
    
    printf("%s\n",buf);
    
     
}

