%*********************************************************************
%
%	Programa: respfrec.m
%
%
%	Fecha: Noviembre 2004
%
%***********************************************************************
clear all;
close all;

%	Generacion senal de entrada
Lx=100;	
n=0:Lx;
x0=cos(pi*n);
x1=cos(pi/2*n);
x2=cos(pi/4*n);
x3=cos(pi/8*n);
%x0=cos(pi/12*n);
%x1=cos(pi/3*n);
x=x0+x1+x2+x3;

%	Dibujo componentes de la senal
figure(1);
subplot(511);
plot(n,x0);
title('Componente x0(n)');
grid
subplot(512);
plot(n,x1);
title('Componente x1(n)');
grid
subplot(513);
plot(n,x2);
title('Componente x2(n)');
grid
subplot(514);
plot(n,x3);
title('Componente x3(n)');
grid
subplot(515);
plot(n,x);
title('x(n)');
grid
disp('Pulse una tecla...')
pause

%      Calculo de la transformada de Fourier
[X,Wx]=dtft(x,500);
%XdB=20*log10(abs(X));

%========================================================
%	Obtencion de respuesta al impulso del filtro
Lh=50;
nh=(-Lh:Lh)+eps;
% Para que salga x3
%W=3/16*pi;
% Para que salga x2+x3 (el filtro paso bajo es mas ancho)
%W=3/8*pi;
% Para que salga x1+x2+x3 (el filtro paso bajo es mas ancho)
W=3/4*pi;
% Para que salga toda la se�al
W=pi;
h=sin(W*nh)./(pi*nh);

%      Calculo de la transformada de Fourier
[H,Wh]=dtft(h,500);
%HdB=20*log10(abs(H));


%====================================================
%	Calculo de la salida y dibujo de la salida y su T.F.

y=conv(x,h);

%      Calculo de la transformada de Fourier
[Y,Wy]=dtft(y,500);
%YdB=20*log10(abs(Y));

%=================================================
%	Representacion de las senhales en tiempo

figure(2);
subplot(311);
plot(n,x);
title('Entrada al filtro: x(n)=x0(n)+x1(n)');
grid

subplot(312)
plot(nh,h)
grid;
title('Respuesta al impulso del filtro, h(n)')

subplot(313)
plot(-Lh:Lx+Lh,y)
axis([0 Lx floor(min(y)) ceil(max(y))])
grid;
title('Salida del filtro')

disp('Pulse una tecla...')
pause

%======================================================
%	Representacion de las senhales en frecuencia



figure(3)
subplot(311);
absX=abs(X);
plot(Wx,absX);
axis([-4 4 0 max(absX)])
title('Entrada, X(W)');
grid

subplot(312)
absH=abs(H);
plot(Wh,absH)
axis([-4 4 0 max(absH)])
grid;
title('Filtro, H(W)')

subplot(313)
absY=abs(Y);
plot(Wy,absY);
axis([-4 4 0 max(absY)])
title('Salida, Y(W)');
grid

