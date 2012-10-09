#include <string.h>
#include "y.tab.h"
#include "funciones.h"

// Sala actual
Sala * sala;
// Inventario
Inventario * inventario;

/***********************/
/* Funciones generales */
/***********************/
int accionInteractuable(Interactuable * it, int acc){
	// Mira si podemos realizar una acción simple con respecto a un interactuable
	if (it==NULL) return 0;
	switch(acc){
		case HABLAR:
			printf("Empiezas a hablar con %s\n",it->nombre);
			ev_hablar(it);
			break;
		default: {printf("No debería leerse esto... (accionInteractuable)"); return -1;}
	}
}

int accion(Objeto * obj, Interactuable * it, int acc){
	// Realiza una acción concreta para un par objeto - interactuable.
	// Comprueba que el objeto es el desencadenante (trigger) del evento del interactuable.
	if ((obj==NULL) | (it==NULL)) return 0;
	int esTrigger; 
	if (it->trigger==NULL) {printf("No se hace nada con el objeto %s\n",obj->nombre); return 0;}
	if (!strcmp(obj->nombre,it->trigger)) esTrigger=1;
	else esTrigger=0;
	switch(acc){
		case USAR:
			if (!esTrigger) {printf("No puedes usarlo con %s\n",obj->nombre); return 0;}
			printf("Has usado %s con %s\n",obj->nombre,it->nombre);
			ev_usarcon(obj,it);
			break;
		case DAR:
			if (!esTrigger) {printf("No puedes darle %s\n",obj->nombre); return 0;}
			printf("Has dado %s a %s\n",obj->nombre,it->nombre);
			ev_dara(obj,it);
			break;
		default:{printf("No debería leerse esto... (accion) \n"); return -1;}
	}
	return 1;
}

int defaultCoger(Objeto * obj){
	// Definicion por defecto del coger, que básicamente crea un nuevo objeto y lo añade al
	// inventario como visible y marca el de la sala con invisible
	Objeto * o = crearObjeto(obj->nombre,obj->desc,obj->estado);
	addInventario(o);
	obj->estado = INVISIBLE;
	return 0;
}

int accionObjeto(Objeto * obj, int acc){
	// Mira si podemos realizar una opción simple con respecto a un objeto de la sala
	if (obj==NULL) return 0;
	switch(acc){
		case COGER:
			printf("Has conseguido %s\n",obj->nombre);
			defaultCoger(obj);
			break;
		default: {printf("No debería leerse esto... (accionObjeto)");}
	}
}

Objeto * objetoInvDisponible(char * obj){
	// Comprobar que el obj está en el inventario (y si es visible)
	int i=0;
	while((i<inventario->nobjetos)&&(strcmp(obj,inventario->objetos[i]->nombre)!=0)) i++;
	if (i==inventario->nobjetos) {printf("No tienes el objeto %s\n",obj);return NULL;}
	Objeto * objeto=inventario->objetos[i];
	if (objeto->estado==INVISIBLE) {printf("No tienes el objeto %s\n",obj);return NULL;}
	else if (objeto->estado==VISIBLE) return objeto;
	else ("ERROR INTERNO: estado?\n");
}

Objeto * objetoSalaDisponible(char * obj){
	// Comprobar que el obj está en la sala (y si es visible)
	int i=0;
	while((i<sala->nobjetos)&&(strcmp(obj,sala->objetos[i]->nombre)!=0)) i++;
	if (i==sala->nobjetos) {printf("No existe el objeto %s en la sala\n",obj);return NULL;}
	Objeto * objeto=sala->objetos[i];
	if (objeto->estado==INVISIBLE) {printf("No hacer eso con %s\n",obj);return NULL;}
	else if (objeto->estado==VISIBLE) return objeto;
	else ("ERROR INTERNO: estado?\n");
}

Interactuable * interactuableDisponible(char * inter,int accion){
	// Comprobar que el interactuable esta en la sala y se puede activar
	// con esa accion concreta.
	int i=0;
	while((i<sala->ninteractuables)&&(strcmp(inter,sala->interactuables[i]->nombre)!=0)) i++;
	if (i==sala->ninteractuables) {printf("No existe el interactuable %s en la sala\n",inter);return NULL;}
	Interactuable * it=sala->interactuables[i];
	if (it->estado==INVISIBLE) {printf("No puedes interactuar con %s\n",inter);return NULL;}
	switch(accion){
		case HABLAR: 
			if (it->dialogo==NOEVENTO) {printf("No puedes dialogar con %s\n",inter); return NULL;}
			break;
		case DAR:
			if (it->dara==NOEVENTO) {printf("No puedes darle algo a %s\n",inter); return NULL;}
			break;
		case USAR:
			if (it->usarcon==NOEVENTO) {printf("%s no puede ser usado!\n",inter); return NULL; }
			break;
		default:{printf("No debería leerse esto... (interactuabkeDisponible)\n"); return NULL;}
	}
	return it;
}

void funinventario(){
	// Muestra el inventario
	int i=0;
	printf("Actualmente tienes:\n");
	while(i<inventario->nobjetos){
		if (inventario->objetos[i]->estado==VISIBLE){
			printf(" -> %s\n",inventario->objetos[i]->nombre);
		}
		i++;
	}
}

int funexaminar(Objeto * obj){
	// Muestra la información de un objeto del inventario
	if (obj==NULL) return 0;
	printf("Examinando objeto de tu inventario:\n -> %s : %s\n",obj->nombre,obj->desc);
	return 1;
}

int funobservar(){
	// Muestra la info de sala actual
	printf("Estás en: %s\n",sala->nombre);
	printf("%s\n",sala->desc);
	int i=0;
	if (sala->nobjetos>0){
		printf("Ves ciertos objetos... :\n");
		while(i<sala->nobjetos){
			if (sala->objetos[i]->estado==VISIBLE) 
				printf(" -> %s\n",sala->objetos[i]->desc);
			i++;
		}
	}
	i=0;
	if (sala->ninteractuables>0){
		printf("Ves ciertas posibilidades... :\n");
		while(i<sala->ninteractuables){
			if (sala->interactuables[i]->estado==VISIBLE)
				printf(" -> %s\n",sala->interactuables[i]->desc);
			i++;
		}
	}
	i=0;
	if (sala->nenlaces>0){
		printf("Ves ciertos lugares a donde poder ir... :\n");
		while(i<sala->nenlaces){
			if (sala->enlaces[i]->estado==VISIBLE)
				printf(" -> %s\n",sala->enlaces[i]->nombre);
			i++;
		}
	}
}

int funira(char * s){
	// Cambia la sala actual por alguna de sus enlaces
	int i=0;
	while((i<sala->nenlaces)&&(strcmp(s,sala->enlaces[i]->nombre)!=0)) i++;
	if (i==sala->nenlaces) {printf("No puedes ir a esa sala!\n");return 0;}
	else if(sala->enlaces[i]->estado==VISIBLE){
		printf("Has ido a %s\n",sala->enlaces[i]->nombre);
		sala = sala->enlaces[i];
		funobservar();
		return 0;
	}
	else printf("No puedes ir allí ahora mismo!\n");
	return 0;
}

int funobservarobj(char * str){
	int i=0;
	while((i<sala->nobjetos)&&(strcmp(str,sala->objetos[i]->nombre)!=0)) i++;
	if ((i<sala->nobjetos) && (sala->objetos[i]->estado==VISIBLE))
	{
		printf("Observas el objeto %s:\n%s\n",sala->objetos[i]->nombre,sala->objetos[i]->desc);
		return 0;
	}
	i=0;
	while((i<sala->ninteractuables)&&(strcmp(str,sala->interactuables[i]->nombre)!=0)) i++;
	if ((i<sala->ninteractuables) && (sala->interactuables[i]->estado==VISIBLE)) 
	{
		printf("Observas el interactuable %s:\n%s\n",sala->interactuables[i]->nombre,sala->interactuables[i]->desc);
		return 0;
	}
	printf("No puedes observar %s\n",str);
	return 1;
}
/************************/
/* Funciones de eventos */
/************************/

//Metemos una serie de "variables globales"
	Sala * s1;
	Sala * s2;
	Sala * s3;


int ev_hablar(Interactuable * it){
  switch(it->dialogo){
      case DIALOGOMUJER:
	printf("- Hola preciosa *sonrisa seductora*\n- Hola... ¡perdedor!\n- ¿Qué haces aquí tan solita? *sonrisa seductora de nuevo*\n- Huir de ti ¬¬\n- ... ... ¡Qué graciosa~~!\n- No es un chiste, es verdad...\n- ... ... ... (Creo que lo mejor es terminar esta conversación)\n");
	break;
      case DIALOGOPERRO:
	printf("- Perrito bonico...\n- Grrrrr\n- Creo que mejor no meterse con él\n");
	break;
      case DIALOGOCALAVERA:
	printf("-¡Ey tu! ¿qué te crees muy listillo?\n- Callate calavera y dime donde está la llave del cajón\n- Por encima de mi cadaver!\nLe das un golpe a la calavera en la cabeza.\n- Vale vale, tú ganas, está en mi ojo. Niñato insolente.\n");
	Objeto * llave;
	llave = crearObjeto("llave","¡Muahahahaha, la llave del poder!",VISIBLE);
	addSalaObjeto(s3,llave);
	it -> desc = strdup("Arghhh una asquerosa calavera parlante.");
	break;
      default: return 0;
  }
    return 1;
}

int ev_usarcon(Objeto * obj, Interactuable * it){
  switch(it->usarcon){
    case CHICLEPERRO:
      printf("Le das el chicle al perro, que tras masticarlo se le queda pegado entre los dientes. Se marcha con el rabo entre piernas.\n- Eso es, marcha, cancerbero del infierno.\n");
      obj -> estado = INVISIBLE;
      sala -> desc = strdup("Un largo pasillo lleno de puertas de despachos, con una plaquita azul que indica los nombres. \nHay una que dice 'Dafonte'. \nLa puerta está cerrada.");
      it -> estado = INVISIBLE;
      break;      
     case HORQUILLAPUERTA:
      printf("Con gran habilidad fuerzas la cerradura\n");
      it -> estado = INVISIBLE;
      s3 -> estado = VISIBLE;
      obj -> estado = INVISIBLE;
      sala -> desc = strdup("Un largo pasillo lleno de puertas de despachos, con una plaquita azul que indica los nombres. \nHay una que dice 'Dafonte'. \nLa puerta del despacho está abierta.\n");
      break;
     case LLAVECAJON:
      printf("Utilizas la llave con el cajón y lo abres\n");
      evento(ESCENAFIN);
      break;
     case APUNTESCHICLE:
      printf("Una buena utilidad para mis apuntes!. Con los apuntes coges un chicle mucho más asqueroso de lo esperado.\n-Arghhh que asco!.\n");
      obj -> estado = INVISIBLE;
      it -> estado = INVISIBLE;
      Objeto * chicleEnvoltorio;
      chicleEnvoltorio = crearObjeto("chicle","Mmm... un delicioso chicle pringoso, viscoso con un ligero tono verdoso, menos mal que tiene un envoltorio\n",VISIBLE); 
      addInventario(chicleEnvoltorio);	
      break;
     default: return 0;
  }
    return 1;
}


int ev_dara(Objeto * obj, Interactuable * it){
    switch(it->dara){
      case DARCONDON:
		printf("Te acercas a la chica, pones tu mejor sonrisa y le enseñas tu flamante condon.\nElla se ofende y antes de que puedas darte cuenta te da una bofetada que resuena en todo el edificio\nEn el proceso de pegarte una horquilla se desprende de su pelo y va a parar al centro de la sala\n- ¡Guauu, como pegan estas mujeres!\nMientras tanto ella se marcha indignada de la sala\n");
		Objeto * horquilla;
		horquilla = crearObjeto("horquilla", "Oh, la horquilla del pelo de la chica",VISIBLE);
		addSalaObjeto(sala,horquilla);
		it->estado = INVISIBLE;
		obj->estado = INVISIBLE;
		break;
      default: return 0;
  }
    return 1;
}

int evento(int escena){
  switch(escena){
    case ESCENAINICIO:
      printf("CAPITULO 20:APROBANDO COMPILADORES\n\nDespues de aprobar IA y DSI por métodos no muy honrosos, ¡llega la hora de Compiladores!\nEstás situado en la entrada de los despachos de la planta 3. Tu objetivo, conseguir el examen sea cual sea el medio empleado!\n- ¡¡¡¡Lo lograré!!!!\n");
      break;
    case ESCENAFIN:
      printf("Finalmente logras conseguir los exámenes de compiladores, ahora solo necesitas que alguien los resuelva por ti ¡y sacar otra matrícula más en tu historial!\n");
      exit(0);
      break;
  }
}

void init(){
	evento(ESCENAINICIO);
	// Crear inventario
	inventario = malloc(sizeof(Inventario));
	inventario->nobjetos=0;
	//Insertamos los objetos iniciales
	Objeto * condon;
	Objeto * apuntes;
	condon = crearObjeto("condon","Un condón. ¡Guardo grandes espectativas para ti!\n",VISIBLE);
	apuntes = crearObjeto("apuntes","Unos apuntes de compiladores, podría estudiarmelos... Nahhhh demasiado trabajo\n",VISIBLE);
	addInventario(condon);
	addInventario(apuntes);
	
	s1 = crearSala("entrada","Estás en una sala con 2 puertas de laboratorios cerradas. \nUn seminario donde unos alumnos gritan a un tal Ares. \nUna chica de buen ver está apoyada en el marco de la puerta. \nA un lado hay una papelera con un chicle viscoso clavado en el borde.",VISIBLE);
	
	Objeto * chicleEnvoltorio;
	chicleEnvoltorio = crearObjeto("chicle","Mmm... un delicioso chicle pringoso, viscoso con un ligero tono verdoso, menos mal que tiene un envoltorio",INVISIBLE); 
	

	Interactuable * chicle;
	Interactuable * mujer;
	chicle = crearInteractuable("chicle","Un chicle viscoso con un ligero color verdoso, no pienso tocar esa cosa!",VISIBLE,NOEVENTO,NOEVENTO,APUNTESCHICLE,"apuntes");
	mujer = crearInteractuable("mujer","Hay una mujer apoyada en la puerta del seminario. Groarrrr, estas informáticas si que saben motivar a uno!!!",VISIBLE, DIALOGOMUJER,DARCONDON,NOEVENTO,"condon");
	
	addSalaObjeto(s1,chicleEnvoltorio);
	addSalaInteractuable(s1,chicle);
	addSalaInteractuable(s1,mujer);

	s2 = crearSala("pasillo","Un largo pasillo lleno de puertas de despachos, con una plaquita azul que indica los nombres. \nHay una que dice 'Dafonte'. \nJusto enfrente de esa puerta hay un doberman asesino que echa espuma por la boca!!",VISIBLE);
	Interactuable * perro;
	Interactuable * puerta;
	perro = crearInteractuable("perro","Enfrente de ti tienes un perro. Oh oh, está echando espuma por la boca, mejor no acercarse mucho...",VISIBLE,DIALOGOPERRO,NOEVENTO,CHICLEPERRO,"chicle");
        puerta = crearInteractuable("puerta", "Mmm... Una puerta de madera con una cerradura estándar.",VISIBLE,NOEVENTO,NOEVENTO,HORQUILLAPUERTA,"horquilla");
	
	addSalaInteractuable(s2,perro);
	addSalaInteractuable(s2,puerta);

	s3 = crearSala("despacho","Un despacho bastante revuelto con una calavera, un ordenador y un cajón cerrado. Seguro que el examen está en el cajón!",INVISIBLE);
	
	
	Interactuable * calavera;
	calavera = crearInteractuable("calavera", "Arghhh una asquerosa calavera.",VISIBLE,DIALOGOCALAVERA,NOEVENTO,NOEVENTO,"");
	Interactuable * cajon;
	cajon = crearInteractuable("cajon", "Un cajon cerrado con llave. ¡En este cajón guarda el examen!",VISIBLE,NOEVENTO,NOEVENTO,LLAVECAJON,"llave");

	addSalaInteractuable(s3,calavera);
	addSalaInteractuable(s3,cajon);
	
	//Enlazamos las salas
	addSalaEnlace(s1,s2);
	addSalaEnlace(s2,s1);
	addSalaEnlace(s2,s3);
	addSalaEnlace(s3,s2);
	// Sala actual
	sala = s1;
}
