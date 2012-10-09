#define SIZEPILA 1000

// PILA DE SIMBOLOS
int spp = -1;
char spila[SIZEPILA];
int spush(char c){
	spp++;
	spila[spp]=c;
	return 0;
}

int spilavacia(){
	if (spp==-1) return 1;
	else return 0;
}
char spop(){
	if (spilavacia()){
		printf("pop: Pila simbolos vacia\n");
		exit(0);
	}
	char c = spila[spp];
	spp--;
	return c;
}

char shead(){
	if (spilavacia()){
		printf("head: Pila simbolos vacia\n");
		exit(0);
	}
	else return spila[spp];
}

// PILA DE ESTADOS

int epp = -1;
int epila[SIZEPILA];
int epush(int c){
	epp++;
	epila[epp]=c;
	return 0;
}

int epilavacia(){
	if (epp==-1) return 1;
	else return 0;
}
int epop(){
	if (epilavacia()){
		printf("pop: Pila estados vacia\n");
		exit(0);
	}
	int c = epila[epp];
	epp--;
	return c;
}

int ehead(){
	if (epilavacia()){
		printf("head: Pila estados vacia\n");
		exit(0);
	}
	else return epila[epp];
}