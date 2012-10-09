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
N = 100;
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
