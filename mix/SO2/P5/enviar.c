#include <sys/types.h>
#include <signal.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>


#define MAXMENSAJE 50

/*prototipos*/
void uso(char * nom);
int senal (char * senal);



void uso(char * nom)
{
  printf("Uso %s -pPID -sSIGNAL -nVECES -dDELAY\n",nom);
  printf("	PID pid del proceso al que se envia l�a senial\n");
  printf("	SIGNAL nombre de la senial (sin el SIG\n");
  printf("	VECES numero de veces que se ha de emviar la senial, opcional\n");
  printf("		un valor negativo indica continuamente, por defecto 1\n");
  printf("	DELAY retardo (en segundos) entre que se le envia la senial\n");
  printf("		una vez y la siguiente. opcional\n");
}
int Senal(char * sen)  /*devuel el numero de senial a partir del nombre*/ 
{			/*si no hay str2sig, hay que hacerlo asi*/
 if (!strcmp(sen,"HUP")) return SIGHUP;
 if (!strcmp(sen,"INT")) return SIGINT;
 if (!strcmp(sen,"QUIT")) return SIGQUIT;
 if (!strcmp(sen,"ILL")) return SIGILL; 
 if (!strcmp(sen,"TRAP")) return SIGTRAP;
 if (!strcmp(sen,"ABRT")) return SIGABRT;
 if (!strcmp(sen,"IOT")) return SIGIOT;
 if (!strcmp(sen,"BUS")) return SIGBUS; 
 if (!strcmp(sen,"FPE")) return SIGFPE;
 if (!strcmp(sen,"KILL")) return SIGKILL;
 if (!strcmp(sen,"USR1")) return SIGUSR1;
 if (!strcmp(sen,"SEGV")) return SIGSEGV;
 if (!strcmp(sen,"USR2")) return SIGUSR2; 
 if (!strcmp(sen,"PIPE")) return SIGPIPE;
 if (!strcmp(sen,"ALRM")) return SIGALRM;
 if (!strcmp(sen,"TERM")) return SIGTERM;
 if (!strcmp(sen,"CHLD")) return SIGCHLD;
 if (!strcmp(sen,"CONT")) return SIGCONT;
 if (!strcmp(sen,"STOP")) return SIGSTOP;
 if (!strcmp(sen,"TSTP")) return SIGTSTP; 
 if (!strcmp(sen,"TTIN")) return SIGTTIN;
 if (!strcmp(sen,"TTOU")) return SIGTTOU;
 if (!strcmp(sen,"URG")) return SIGURG;
 if (!strcmp(sen,"XCPU")) return SIGXCPU; 
 if (!strcmp(sen,"XFSZ")) return SIGXFSZ;
 if (!strcmp(sen,"VTALRM")) return SIGVTALRM;
 if (!strcmp(sen,"PROF")) return SIGPROF;
 if (!strcmp(sen,"WINCH")) return SIGWINCH; 
 if (!strcmp(sen,"IO")) return SIGIO;
 if (!strcmp(sen,"SYS")) return SIGSYS;
/*senales que no hay en todas partes*/
#ifdef SIGPOLL
 if (!strcmp(sen,"POLL")) return SIGPOLL;
#endif
#ifdef SIGPWR
 if (!strcmp(sen,"PWR")) return SIGPWR;
#endif
#ifdef SIGEMT
 if (!strcmp(sen,"EMT")) return SIGEMT;
#endif
#ifdef SIGINFO
 if (!strcmp(sen,"INFO")) return SIGINFO;
#endif
#ifdef SIGSTKFLT
 if (!strcmp(sen,"STKFLT")) return SIGSTKFLT;
#endif
#ifdef SIGCLD
 if (!strcmp(sen,"CLD")) return SIGCLD;
#endif
#ifdef SIGLOST
 if (!strcmp(sen,"LOST")) return SIGLOST;
#endif
#ifdef SIGCANCEL
 if (!strcmp(sen,"CANCEL")) return SIGCANCEL;
#endif
#ifdef SIGTHAW
 if (!strcmp(sen,"THAW")) return SIGTHAW;
#endif
#ifdef SIGFREEZE
 if (!strcmp(sen,"FREEZE")) return SIGFREEZE;
#endif
#ifdef SIGLWP
 if (!strcmp(sen,"LWP")) return SIGLWP;
#endif
#ifdef SIGWAITING
 if (!strcmp(sen,"WAITING")) return SIGWAITING;
#endif
 return  (-1);
}

char *NombreSenal(int sen)  /*devuelve el nombre senal */ 
{			/*si no hay sig2str, hay que hacerlo asi*/

    if (sen == SIGHUP) return "SIGHUP";
    if (sen == SIGINT) return "SIGINT";
    if (sen == SIGQUIT) return "SIGQUIT";
    if (sen == SIGILL) return "SIGILL"; 
    if (sen == SIGTRAP) return "SIGTRAP";
    if (sen == SIGABRT) return "SIGABRT";
    if (sen == SIGIOT) return "SIGIOT";
    if (sen == SIGBUS) return "SIGBUS"; 
    if (sen == SIGFPE) return "SIGFPE";
    if (sen == SIGKILL) return "SIGKILL";
    if (sen == SIGUSR1) return "SIGUSR1";
    if (sen == SIGSEGV) return "SIGSEGV";
    if (sen == SIGUSR2) return "SIGUSR2"; 
    if (sen == SIGPIPE) return "SIGPIPE";
    if (sen == SIGALRM) return "SIGALRM";
    if (sen == SIGTERM) return "SIGTERM";
    if (sen == SIGCHLD) return "SIGCHLD";
    if (sen == SIGCONT) return "SIGCONT";
    if (sen == SIGSTOP) return "SIGSTOP";
    if (sen == SIGTSTP) return "SIGTSTP"; 
    if (sen == SIGTTIN) return "SIGTTIN";
    if (sen == SIGTTOU) return "SIGTTOU";
    if (sen == SIGURG) return "SIGURG";
    if (sen == SIGXCPU) return "SIGXCPU"; 
    if (sen == SIGXFSZ) return "SIGXFSZ";
    if (sen == SIGVTALRM) return "SIGVTALRM";
    if (sen == SIGPROF) return "SIGPROF";
    if (sen == SIGWINCH) return "SIGWINCH"; 
    if (sen == SIGSYS) return "SIGSYS";
    if (sen == SIGIO) return "SIGIO";
/*estas senales no las hay en todos partes*/
#ifdef SIGPOLL
    if (sen == SIGPOLL) return "SIGPOLL";
#endif
#ifdef SIGPWR
    if (sen == SIGPWR) return "SIGPWR";
#endif
#ifdef SIGINFO
    if (sen == SIGINFO) return "SIGINFO";
#endif
#ifdef SIGEMT
    if (sen == SIGEMT) return "SIGEMT";
#endif
#ifdef SIGSTKFLT
 if (sen == SIGSTKFLT) return "SIGSTKFLT";
#endif
#ifdef SIGCLD
 if (sen == SIGCLD) return "SIGCLD";
#endif
#ifdef SIGLOST
 if (sen == SIGLOST) return "SIGLOST";
#endif
#ifdef SIGCANCEL
 if (sen == SIGCANCEL) return "SIGCANCEL";
#endif
#ifdef SIGTHAW
 if (sen == SIGTHAW) return "SIGTHAW";
#endif
#ifdef SIGFREEZE
 if (sen == SIGFREEZE) return "SIGFREEZE";
#endif
#ifdef SIGLWP
 if (sen == SIGLWP) return "SIGLWP";
#endif
#ifdef SIGWAITING
 if (sen == SIGWAITING) return "SIGWAITING";
#endif
 return ("SIGUNKNOWN");
}

main (int argc, char * argv[])
{
 pid_t pid;
 char *nombresenal;
 int sen=0;
 int veces=1;
 int delay=0;
 int i;
 char mensaje[MAXMENSAJE];
 
 i=1;
 while (argv[i]!=NULL) {
    if (!strncmp (argv[i],"-p",2))
        pid=(pid_t)atoi(argv[i]+2);
    if (!strncmp (argv[i],"-s",2)){
        sen=Senal(argv[i]+2);
	nombresenal=argv[i]+2;
	}
    if (!strncmp (argv[i],"-n",2))
        veces=atoi(argv[i]+2);
    if (!strncmp (argv[i],"-d",2))
        delay=atoi(argv[i]+2);
    i++;
	}
 if (pid==(pid_t)0 || sen==0){ /*no se ha especificado pid o senal*/
     uso(argv[0]);
     exit(0);
     } 
 if (sen==-1){ /*se ha especificado una senal que no existe*/
     printf ("No existe senal SIG%s\n",nombresenal);
     exit(0);
     }
 
 if (kill(pid,0)==-1){	/*no hay tal proceso o permisos*/
     sprintf(mensaje,"Error al enviar senales al proceso %u",(unsigned) pid);
     perror (mensaje);
     exit(0);
     }
if (delay==0)
  while (veces-- && (kill(pid,sen)!=-1));
else
  while (veces-- && (kill(pid,sen)!=-1))
     sleep (delay);
}
