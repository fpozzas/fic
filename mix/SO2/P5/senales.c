/******************************SENALES ******************************************/
int Senal(char * sen)  /*devuel el numero de senial a partir del nombre*/ 
{			/*para sitios donde no hay str2sig*/
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

char *NombreSenal(int sen)  /*devuelve el nombre senal a partir de la senal*/ 
{			/* para sitios donde no hay sig2str*/

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
