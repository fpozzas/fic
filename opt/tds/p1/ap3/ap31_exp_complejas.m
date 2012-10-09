close all;
% Apartado 3
% 3.1 Exponenciales complejas

% EJERCICIO 1
% Sea r=0.9 y phi=45 grados = pi/4
r=0.9;
phi=pi/4;
L = 0:20;
rexp = genexp(0.9,0,size(L,2))';
xn = rexp.*cos(phi*L) + 1j*(rexp.*sin(phi*L));
figure(1);
stem(0:20,xn);
title('Exponencial compleja');
% Representación 
subplot(211);
stem(0:20,real(xn));
title('Parte real');
xlabel('Indice (n)'); 
subplot(212);
stem(0:20,imag(xn));
title('Parte imaginaria');
xlabel('Indice (n)');

