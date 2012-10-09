% Alumno: Daniel Fernández Núñez
function []=tf_analisis_x2(N,M)
% x2 es la convolución de x1 consigo
% misma, por lo que la TF de x2 es
% el cuadrado de la TF de x1

% Muestreo
k = 0:N-1;
w = 2*pi*k/N;
x_num =exp(-1j*w*M).*sin(w*(M+0.5));
x_den = sin(w/2);
x = x_num./x_den;
% Workarround para solucionar la indeterminación de w=0
x(1) = 2*M+1;
x = x.*x;

figure(2);
subplot(2,4,1);
plot(0:2*pi/N:2*pi*(N-1)/N,real(x));
axis([0 2*pi ylim]);
title('ANALITICA: Parte real de X2');
xlabel('Indice (n)'); 
subplot(2,4,5);
plot(0:2*pi/N:2*pi*(N-1)/N,imag(x));
axis([0 2*pi ylim]);
title('ANALITICA: Parte imag de X2');
xlabel('Indice (n)');
