#include <X11/Xlib.h> 
#include <X11/Xutil.h> 
#include <X11/Xos.h>
#include <stdio.h> 
#include <stdlib.h> 
#include <string.h>
	
int main(argc, argv) 
	int argc; 
	char **argv;
{
Display *d;
unsigned int width,height,display_width,display_height,window_width,window_height;
int s;
int x = 0;
int y = 0;
Window w;
char *window_name = "Hola mundo!";
char *icon_name = "icono";
char cd_height[50], cd_width[50], cd_depth[80];
XEvent e;
XSizeHints size_hints;

/* Abrimos una conexión con el servidor X */
d=XOpenDisplay(NULL);
if(d==NULL) {
	printf("No se puede abrir un display\n");
	exit(1);
}

s=DefaultScreen(d);

/* Obtenemos el tamaño de la pantalla */
display_width = DisplayWidth(d,s); 
display_height = DisplayHeight(d,s);

/* Establecemos cómo de grande será la ventana en proporción al display */

window_width = display_width/3;
window_height = display_height/4;
	
/* Creamos una ventana */
w=XCreateSimpleWindow(d, RootWindow(d, s), x, y, window_width, window_height, 1,
						BlackPixel(d, s), WhitePixel(d, s));

/* Creamos ciertas restricciones referentes al tamaño de nuestra ventana, */
size_hints.flags = PPosition | PSize | PMinSize; 
size_hints.x = x;
size_hints.y = y;
size_hints.width = window_width;
size_hints.height = window_height;
size_hints.min_width = 200;
size_hints.min_height = 200;

/* La siguiente función es útil para decirle al gestor de ventanas cómo
queremos que muestre nuestra ventana  */

XSetStandardProperties(d, w, window_name, icon_name, None, argv, argc, &size_hints);

/* Selecionamos los eventos que queremos que la ventana tenga en cuenta */
XSelectInput(d, w, ExposureMask | KeyPressMask);

/* Mostramos la ventana */
XMapWindow(d, w);

/* Bucle de eventos */
while(1) {
	XNextEvent(d, &e);
	/* Dibujamos o redibujamos la ventana */
	if(e.type==Expose) {
		/* Dibujamos unos rectangulos */
		height = window_height/2;
		width = 3 * window_width/4;
		
		x = window_width/2 - width/2; 
		y = window_height/2 - height/2;
		
		XDrawRectangle(d, w, DefaultGC(d, s), x, y, width, height);
		XDrawRectangle(d, w, DefaultGC(d, s), x-5, y-5, width+10, height+10);
		XDrawRectangle(d, w, DefaultGC(d, s), x-10, y-10, width+20, height+20);
		/* Dibujamos el texto */
		sprintf(cd_height,"    Alto: %d pixels", DisplayHeight(d,s));
		sprintf(cd_width,"    Ancho: %d pixels", DisplayWidth(d,s));
		sprintf(cd_depth,"    Profundidad de la ventana: %d planos", DefaultDepth(d,s));
		XDrawString(d, w, DefaultGC(d, s), window_width/6, window_height/3+10, "Hola, este es un ejemplo del uso de las Xlib.",
				strlen("Hola, este es un ejemplo del uso de las Xlib."));
		XDrawString(d, w, DefaultGC(d, s), window_width/6, window_height/3+10+15, "Tu pantalla tiene las siguientes caracteristicas:",
				strlen("Tu pantalla tiene las siguientes caracteristicas:"));
		XDrawString(d, w, DefaultGC(d, s), window_width/6, window_height/3+10+30, cd_height,
				strlen(cd_height));
		XDrawString(d, w, DefaultGC(d, s), window_width/6, window_height/3+10+40, cd_width,
				strlen(cd_width));
		XDrawString(d, w, DefaultGC(d, s), window_width/6, window_height/3+10+50, cd_depth,
				strlen(cd_depth));
	}
	/* Salimos del programa cuando pulsamos una tecla */
	if(e.type==KeyPress)
	break;
}

	/* Cerramos la conexión con el servidor */
	XCloseDisplay(d);
	
	return 0;
}
