#include <GL/glut.h>

// Variables globales que controlan el estado de la noria
GLfloat anguloNoria=0;      // Giro de la noria
GLfloat anguloFiguraY=25;    // Angulo de visualización
int ratonX,ratonY;          // Coordenadas del ratón

GLint ancho=400;    // Ancho y alto de la ventana
GLint alto=400;

GLfloat DistCam=-10.0f;     // Distancia del objeto a la cámara
GLfloat velocidadGiro=1;    // Velocidad de giro de la noria
GLint sentidoGiro=1;        // Sentido de giro de la noria +1,-1

/*
  Función reshape llamada cada vez que se modifica el tamaño de la ventana
*/
void reshape(int width, int height)
{
    glViewport(0, 0, width, height);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(60.0f, (GLfloat)width/(GLfloat)height, 1.0f, 50.0f);
    glMatrixMode(GL_MODELVIEW);

    ancho = width;
    alto = height;
}

/*
  Función que dibuja una cesta alineada verticalmente, separada 4 unidades del origen
   y con un ángulo determinado
*/
void dibujaCesta(GLfloat angulo)
{
    glPushMatrix(); // Hacemos un push para que las transformaciones no afecten al resto de los objetos

    glTranslatef(0.0f,-0.5f,0.0f);  // Este es para que cuelguen del lado de arriba en lugar de sobre el centro
    glRotatef(angulo,0.0f,0.0f,1.0f);
    glTranslatef(4.0f,0.0f,0.0f);
    glRotatef(-angulo,0.0f,0.0f,1.0f);
    glutSolidCube(1.0f);

    glPopMatrix();  // Recuperamos la matriz de transformaciones para dejarlo todo como estaba.
}

/*
  Macro para dibujar un cilindro, dado que no existe la función glutSolidCylinder(), la creamos utilizando gluCylinder, más genérica.
*/
#define glutSolidCylinder(radio, altura, slices, stacks) gluCylinder(gluNewQuadric(), radio, radio, altura, slices, stacks)

/*
  Función que dibuja la estructura de la noria, esto es, los radios y las circunferencias
*/
int dibujaEstructura(GLfloat angulo)
{
    int i;

    glPushMatrix();

    glColor3f(1.0f,1.0f,1.0f);

    glRotatef(angulo,0.0f,0.0f,1.0f);
    glTranslatef(0.0f,0.0f,-0.5f);
    glPushMatrix();
    glRotatef(90,1.0f,0.0f,0.0f);
    for(i=0;i<8;i++)
    {
        glRotatef(45,0.0f,1.0f,0.0f);
	    glutSolidCylinder(0.1f,4.0f,10,1);  // Radios de la rueda de la noria
    }
    glPopMatrix();
    glutSolidTorus(0.1f,4.0f,10,50);  // Estructura de la rueda de la noria

    glTranslatef(0.0f,0.0f,1.0f);

    glPushMatrix();
    glRotatef(90,1.0f,0.0f,0.0f);
    for(i=0;i<8;i++)
    {
        glRotatef(45,0.0f,1.0f,0.0f);
       	glutSolidCylinder(0.1f,4.0f,10,1);  // Radios del otro lado
    }
    glPopMatrix();
    glutSolidTorus(0.1f,4.0f,10,50);  // Estructura del otro lado

    glPopMatrix();

}

/*
  Función que dibuja la base de la noria
*/
void dibujaBase()
{
    glPushMatrix();

    glPushMatrix();
    glTranslatef(0.0f,0.0f,0.8f);
    glutSolidSphere(0.15,10,10);    // Esfera de unión
    glRotatef(40,0.0f,0.0f,1.0f);
    glRotatef(90,1.0f,0.0f,0.0f);
    glutSolidCylinder(0.15f,7.0f,10,1);  // Barrotes de agarre de la rueda
    glPopMatrix();

    glPushMatrix();
    glTranslatef(0.0f,0.0f,0.8f);
    glRotatef(-40,0.0f,0.0f,1.0f);
    glRotatef(90,1.0f,0.0f,0.0f);
    glutSolidCylinder(0.15f,7.0f,10,1);  // Barrotes de agarre de la rueda
    glPopMatrix();

    glPushMatrix();
    glTranslatef(0.0f,0.0f,-0.8f);
    glutSolidCylinder(0.15f,1.6f,10,1);    // Barra horizontal
    glutSolidSphere(0.15,10,10);    // Esfera de unión
    glRotatef(40,0.0f,0.0f,1.0f);
    glRotatef(90,1.0f,0.0f,0.0f);
    glutSolidCylinder(0.15f,7.0f,10,1);  // Barrotes de agarre de la rueda
    glPopMatrix();

    glPushMatrix();
    glTranslatef(0.0f,0.0f,-0.8f);
    glRotatef(-40,0.0f,0.0f,1.0f);
    glRotatef(90,1.0f,0.0f,0.0f);
    glutSolidCylinder(0.15f,7.0f,10,1);  // Barrotes de agarre de la rueda
    glPopMatrix();

    glTranslatef(0.0f,-5.5f,0.0f);
    glScalef(10.0f,1.0f,2.0f);
    glutSolidCube(1.0f);        // Caja de base
    
    glPopMatrix();
}

/*
  Función display, que dibuja la noria cada vez que es llamada
*/
void display()
{
    int i;

    // Borramos lo que haya en el buffer
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    // Definimos sombreado suave
    glShadeModel(GL_SMOOTH);

    // Cargamos la matriz identidad para reiniciar las transformaciones
    glLoadIdentity();

    // Colocamos una luz
    glLightfv(GL_LIGHT0,GL_DIFFUSE,(GLfloat []){1.0f,1.0f,1.0f,1.0f}); // Color de la luz
    glLightfv(GL_LIGHT0,GL_AMBIENT,(GLfloat []){0.5f,0.5f,0.5f,1.0f}); // Luz ambiente
    glLightfv(GL_LIGHT0,GL_POSITION,(GLfloat []){-7.0f,12.0f,0.0f,1.0f}); // Posición de la luz


    // Movemos el objeto lejos de la camara para verlo bien
    glTranslatef(0.0f, 0.0f, DistCam);
    
    // Giro de la figura según el ratón
    glRotatef(anguloFiguraY,1.0f,0.0f,0.0f);

    glColor3f(1.0f,1.0f,1.0f);

    // Dibujamos las 8 cestas, repartidas en un círculo, teniendo en cuenta
    //  el ángulo actual de la noria.
    for(i=0;i<8;i++)
	dibujaCesta(i*45+anguloNoria);

	// Dibujamos la estructura que sustenta las cestas, también con el ángulo actual
    dibujaEstructura(anguloNoria);

    // Dibujamos la base, que está quieta
    dibujaBase();

    // Pasamos todo esto que hemos dibujado en el buffer a la ventana
    glFlush();
    glutSwapBuffers();

}

/*
  Función de control del menú del ratón
*/
void menuapp(int i)
{
    // Las velocidades de giro se actualizan teniendo en cuenta el sentido
    //  actual de giro de la noria.
    switch(i)
    {
    case 1: velocidadGiro=sentidoGiro*1;break;  // Velocidad de giro lenta
    case 2: velocidadGiro=sentidoGiro*2;break;  // Velocidad de giro media
    case 3: velocidadGiro=sentidoGiro*4;break;  // Velocidad de giro rápida
    case 0: exit(0);    // Salir del programa
    }
}

/*
  Función de inicialización
*/
void init()
{
    glClearColor(0,0,0,0);    // Definimos el negro como color de fondo
    glEnable(GL_DEPTH_TEST);  // Activamos el z-Buffer
    glEnable(GL_LIGHTING);    // Activamos la iluminación
    glEnable(GL_LIGHT0);      // Activamos la luz 0
    ancho = 400;        // Ancho y alto por defecto de la ventana
    alto = 400;

    // Creamos el menú del ratón y le asignamos su función de control
    glutCreateMenu(menuapp);  // Asignamos la función de control
    glutAddMenuEntry("Lento", 1);  // Añadimos los elementos del menú
    glutAddMenuEntry("Medio", 2);
    glutAddMenuEntry("Rapido", 3);
    glutAddMenuEntry("Salir",0);
    glutAttachMenu(GLUT_RIGHT_BUTTON);  // Asignamos el menú a la pulsación del botón derecho del ratón
}

/*
  Función que es llamada cada vez que se requiere actualizar la escena por que
   se ha movido la geometría (animación)
*/
void Animar()
{
    // Actualizamos la ventana, aumentamos o disminuimos el ángulo de la noria
    //  y hacemos la siguiente llamada para volver a animar
    display();
    anguloNoria+=velocidadGiro;
    glutTimerFunc(33, Animar, 1);
}
 
/*
  Función de control del teclado
*/
void keyboard(unsigned char key, int x, int y)
{
    switch(key)
    {
    case '+':        // Acercarse a la figura
	DistCam+=0.1f;
	break;
    case '-':        // Alejarse de la figura
	DistCam-=0.1f;
        break;
    case 'r':        // Cambiar el sentido de giro de la noria
    case 'R':
	velocidadGiro=-velocidadGiro;
	sentidoGiro=-sentidoGiro;
	display();
	break;
    case 27:   // escape
      exit(0);
      break;
    }
}

/*
  Función de control del momvimiento del ratón
*/
void raton(int Button, int State, int x, int y)
{
    // Actualizamos las coordenadas del ratón si este se mueve
    ratonX=x;
    ratonY=y;
}

/*
  Función de control del movimiento de arrastre del ratón
*/
void moverRaton(int x, int y)
{
    // Si se arrastra el ratón con el botón pulsado, modificamos el ángulo de
    //  la figura, y actualizamos
    anguloFiguraY+=(y-ratonY);
    ratonX=x;
    ratonY=y;

    display();
}

int main(int argc, char **argv)
{
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB);
    glutInitWindowPosition(100, 100);
    glutInitWindowSize(ancho, alto);
    glutCreateWindow("Noria");
    init();
    glutTimerFunc(33, Animar, 1);
    glutDisplayFunc(display);
    glutReshapeFunc(reshape);
    glutKeyboardFunc(keyboard);
    glutMouseFunc(raton);
    glutMotionFunc(moverRaton);

    glutMainLoop();
    return 0;
}
