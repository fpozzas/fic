% Alumno: Daniel Fernández Núñez
% Apartado 3 Análisis y aplicación de un sistema
close all;
clear all;
% Sistema 1 %
B1 = [1 0];
A1 = [1 0.7];
% Sistema 2 %
B2 = [1 -1];
A2 = [1 0.7];
% Sistema 3 %
B3 = [1 0 0];
A3 = [1 0 0.81];	
% Sistema 4 %
B4 = [1 -0.5 0];
A4 = [1 -0.7071 0.25];
% Sistema 5 %
Z5 = [-1 ; -1];
P5 = [0.2315+0.3951j ; 0.2315-0.3951j]; 
B5 = poly(Z5);
A5 = poly(P5);

% Representaciones para todos los sistemas

dibuja(B1,A1);
dibuja(B2,A2);
dibuja(B3,A3);
dibuja(B4,A4);
dibuja(B5,A5);

disp('Representaciones para todos los sistemas');
disp('Enter para continuar...');
pause;
close all;

% Salidas del sistema 5
N = 200;
n = 0:N-1;
% x1
x1 = sin(2*pi*(1000/8000)*n);
y1 = filter(B5,A5,x1);
% x2
x2 = sin(2*pi*(3500/8000)*n);
y2 = filter(B5,A5,x2);
% Representaciones
figure;
subplot(221);
plot(n,x1);
title('x1');
subplot(222);
plot(n,x2);
title('x2');
subplot(223);
plot(n,y1);
title('y1');
subplot(224);
plot(n,y2);
title('y2');

disp('Señales de entrada para el sistema 5');
disp('Enter para continuar...');
pause;
close all;

% Modificación del sistema 4
% Para que la respuesta en frecuencia sea 0 en 0 y 4000
% hay que poner un polo en -1 y otro en 1
B6 = poly([-1 ; 1]);
A6 = A4;

% Parametros del dibujo
N = 512;
Fs = 8000;

figure;
% Planos Z
subplot(121);
zplane(B4,A4);
title('Antes');
subplot(122);
zplane(B6,A6);
title('Despues');
% Respuestas en frecuencia
figure;
subplot(121);
[H,F] = freqz(B4,A4,N,'whole',Fs);
plot(F,abs(H));
xlabel('Hz');
title('Antes');
subplot(122);
[H,F] = freqz(B6,A6,N,'whole',Fs);
plot(F,abs(H));
xlabel('Hz');
title('Despues');
% Salidas para x1 e x2
figure;
subplot(221);
plot(n,filter(B4,A4,x1));
title('Antes para x1');
subplot(222);
plot(n,filter(B4,A4,x2));
title('Antes para x2');
subplot(223);
plot(n,filter(B6,A6,x1));
title('Despues para x1');
subplot(224);
plot(n,filter(B6,A6,x2));
title('Despues para x2');

disp('Modificación para el sistema 4');
disp('Enter para terminar.');
