%*********************************************************************
%
%	Programa: respfrec.m
%
%
%	Fecha: Diciembre 2002
%
%***********************************************************************
clear all;
close all;

%	Generacion senal de entrada
Lx=100;	
n=0:Lx;
x0=cos(pi/12*n);
x1=cos(pi/3*n);
x=x0+x1;


%	Dibujo componentes de la senal
figure(1);
subplot(211);
plot(n,x0);
title('Componente x0(n)');
grid
subplot(212);
plot(n,x1);
title('Componente x1(n)');
grid


%	Dibujo de la suma de componentes y su T.F.
figure(2);
subplot(211);
plot(n,x);
title('Entrada al filtro: x(n)=x0(n)+x1(n)');
grid
subplot(212);
[X,W]=dtft(x,500);
plot(W,abs(X));
title('X(W)');
grid


%	Obtencion de respuesta al impulso y respuesta en frecuencia
Lh=50;
nh=(-Lh:Lh)+eps;


% 	Filtro paso bajo
h=sin(0.1*pi*nh)./(pi*nh);
[H,W]=dtft(h,500);


%	Dibujo respuesta al impulso y respuesta en frecuencia
figure(3)
subplot(211)
plot(nh,h)
grid;
title('Respuesta al impulso')
subplot(212)
plot(W,abs(H))
grid;
title('Respuesta en frecuencia')


%	Calculo y dibujo de la salida y su T.F.
figure(4);
y=conv(x,h);
subplot(211)
plot(-Lh:Lx+Lh,y)
axis([0 Lx floor(min(y)) ceil(max(y))])
grid;
title('Salida del filtro')
subplot(212)
[Y,W]=dtft(y,500);
plot(W,abs(Y));
title('Y(W)');
grid


