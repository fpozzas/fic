/*
   Simple Xlib application drawing a box in a window.
 */
 
 #include <X11/Xlib.h> include <stdio.h> include <stdlib.h> include <string.h>
 
 int main() {
   Display *d;
   int s;
   Window w;
   XEvent e;
 
                        /* open connection with the server */
   d=XOpenDisplay(NULL);
   if(d==NULL) {
     printf("Cannot open display\n");
     exit(1);
   }
   s=DefaultScreen(d);
 
                        /* create window */
   w=XCreateSimpleWindow(d, RootWindow(d, s), 10, 10, 1000, 100, 1,
                         BlackPixel(d, s), WhitePixel(d, s));
 
                        /* select kind of events we are interested in */
   XSelectInput(d, w, ExposureMask | KeyPressMask);
 
                        /* map (show) the window */
   XMapWindow(d, w);
 
                        /* event loop */
   while(1) {
     XNextEvent(d, &e);
                        /* draw or redraw the window */
     if(e.type==Expose) {
       XFillRectangle(d, w, DefaultGC(d, s), 20, 20, 10, 10);
       XDrawString(d, w, DefaultGC(d, s), 50, 50, "Hello, World!",strlen("Hello, World!"));
     }
                        /* exit on key press */
     if(e.type==KeyPress)
       break;
   }
 
                        /* close connection to server */
   XCloseDisplay(d);
 
   return 0;
 }
