close all;
% Apartado 2
% 2.2 Sinusoides

% EJERCICIO 1
figure(1);
hold on;
% x1
L = 0:(pi/17):25;
subplot(4,1,1);
stem(L,sin(L));
axis([0 25 -1 1]);
title('x1(n)');
% x2
Lr = 0:(pi/17):25;
Ll = fliplr(-pi/17:-pi/17:-15);
L = [Ll,Lr];
subplot(4,1,2);
stem(L,sin(L));
axis([-15 25 -1 1]);
title('x2(n)');
% x3
Lr = 0:(3*pi):11;
Ll = fliplr(-3*pi:-3*pi:-10);
L = [Ll,Lr];
subplot(4,1,3);
stem(L,sin(L+pi/2));
axis([-10 11 -1 1]);
title('x3(n)');
% x4
L = 0:(pi/sqrt(23)):50;
subplot(4,1,4);
stem(L,cos(L));
axis([0 50 -1 1]);
title('x4(n)');
% Una secuencia que imita a x3 sería la siguiente:
% secuencia(n) = (-1)^n * SUM(k=0:1; delta(n-3*pi*k))
% Si consideramos dos señales iguales a:
% s(n) = SUM(l=0:M-1; A_l * delta(n-l*P - n_0))
% Sea:
% x3 = s1(n) + s2(n)
% Donde para s1:
% A_l = 2
% M = 1;
% P = 6*pi
% y para s2:
% A_l = -1
% M = 1;
% P = 3*pi

% EJERCICIOS 2 y 3
% Se crean las funciones:
% function [sinv] = seno(A,w,phi,nmin,nmax)
% y
% function [indices,sinv] = seno2(A,w,phi,nmin,nmax)
% Comprobamos su funcionamiento dibujado el ejemplo propuesto
% (mediante seno2 porque es más sencillo dibujarla ya que
% devuelve los índices)
figure(2);
[sini,sinv] = seno2(2,pi/11,0,-20,20);
stem(sini,sinv);
title('Ejemplo propuesto obtenido de seno2.m');