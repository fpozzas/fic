% Alumno: Daniel Fernández Núñez
function []=tf_analisis_x1(N,M)
% x1 es la secuencia ejemplo (2) desplazada
% en M a la derecha, por lo que su TF es la
% TF de x1 multiplicado por un exponencial

% Muestreo
k = 0:N-1;
w = 2*pi*k/N;
x_num =exp(-1j*w*M).*sin(w*(M+0.5));
x_den = sin(w/2);
x = x_num./x_den;
% Workarround para solucionar la indeterminación de w=0
x(1) = 2*M+1;

figure(2);
subplot(2,4,1);
plot(0:2*pi/N:2*pi*(N-1)/N,abs(x));
axis([0 2*pi ylim]);
title('ANALITICA: modulo de X1');
xlabel('Indice (n)'); 
subplot(2,4,5);
plot(0:2*pi/N:2*pi*(N-1)/N,imag(x));
axis([0 2*pi ylim]);
title('ANALITICA: fase de X1');
xlabel('Indice (n)');
