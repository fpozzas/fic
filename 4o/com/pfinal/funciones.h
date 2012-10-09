#define TAMDESC 255
#define TAMNOMBRE 15
#define TAMARRAY 50
#define TAMENLACES 10
#define TAMSALAS 10

#define VISIBLE 1
#define INVISIBLE 0

#define NOEVENTO 0

// Defines de los eventos
#define DIALOGOMUJER 1
#define DIALOGOPERRO 2
#define DIALOGOCALAVERA 3

#define CHICLEPERRO 1
#define HORQUILLAPUERTA 2
#define LLAVECAJON 3
#define APUNTESCHICLE 4

#define DARCONDON 1

#define ESCENAINICIO 1
#define ESCENAFIN 2

struct tObjeto{
	char* nombre;
	char* desc;
	int estado;
};

typedef struct tObjeto Objeto;

struct tInteractuable{
	char* nombre;
	char* desc;
	int estado;
	int dialogo; 
	int dara; 
	int usarcon;
	char* trigger;
};

typedef struct tInteractuable Interactuable;

struct tSala;
typedef struct tSala Sala;

struct tSala{
	char* nombre;
	char* desc;
	int estado;
	Sala * enlaces[TAMSALAS];
	int nenlaces;
	Interactuable * interactuables[TAMARRAY];
	int ninteractuables;
	Objeto * objetos[TAMARRAY];
	int nobjetos;
};

//typedef struct tSala Sala;

struct tInventario{
	Objeto * objetos[TAMARRAY];
	int nobjetos;
};

typedef struct tInventario Inventario;

/**********************/
/* Variables globales */
/**********************/

// Sala actual
Sala * sala;
// Inventario
Inventario * inventario;
/*********************/
/* Funciones del API */
/*********************/

/*********************/
/* Funciones del API */
/*********************/

Objeto * crearObjeto(char * nombre, char * desc, int estado){
	Objeto * obj = malloc(sizeof(Objeto));
	obj->nombre = strdup(nombre);
	obj->desc = strdup(desc);
	obj->estado = estado;
	return obj;
}

Interactuable * crearInteractuable(char * nombre, char * desc, int estado, int dialogo, int dara, int usarcon, char* trigger){
	Interactuable * it = malloc(sizeof(Interactuable));
	it->nombre = strdup(nombre);
	it->desc = strdup(desc);
	it->estado = estado;
	it->dialogo = dialogo;
	it->dara = dara;
	it->usarcon = usarcon;
	if (trigger!=NULL) it->trigger = strdup(trigger);
	else it->trigger = NULL;
	return it;
}

int addInventario(Objeto * obj){
	inventario->objetos[inventario->nobjetos] = obj;
	inventario->nobjetos++;
	return 1;
}

int addSalaObjeto(Sala * s, Objeto * obj ){
	s->objetos[s->nobjetos] = obj;
	s->nobjetos++;
	return 1;
}

int addSalaInteractuable(Sala * s, Interactuable * it ){
	s->interactuables[s->ninteractuables] = it;
	s->ninteractuables++;
	return 1;
}

Sala * crearSala(char * nombre, char * desc, int estado){
	Sala * s = malloc(sizeof(Sala));
	s->nombre = strdup(nombre);
	s->desc = strdup(desc);
	s->estado = estado;
	s->nobjetos = 0;
	s->ninteractuables = 0;
	return s;
}

int addSalaEnlace(Sala * s, Sala * s2){
	s->enlaces[s->nenlaces] = s2;
	s->nenlaces++;
	return 1;
}

/***********************/
/* Funciones generales */
/***********************/

int accionInteractuable(Interactuable * it, int acc);
int accion(Objeto * obj, Interactuable * it, int acc);
int defaultCoger(Objeto * obj);
int accionObjeto(Objeto * obj, int acc);
Objeto * objetoInvDisponible(char * obj);
Objeto * objetoSalaDisponible(char * obj);
Interactuable * interactuableDisponible(char * inter,int accion);
void funinventario();
int funexaminar(Objeto * obj);
int funobservar();
int funira(char * s);

int ev_hablar(Interactuable * it);
int ev_usarcon(Objeto * obj, Interactuable * it);
int ev_dara(Objeto * obj, Interactuable * it);
void init();