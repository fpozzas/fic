close all;
% Apartado 2
% 2.1 Impulsos

% EJERCICIO 1
figure(1);
hold on;
% x1
L = 20;
x1 = zeros(L,1);
x1(5) = 0.9;
subplot(4,1,1);
stem(1:20,x1);
title('x1(n)');
% x2
L = 31;
x2 = zeros(L,1);
x2(16) = 0.8;
subplot(4,1,2);
stem(-15:15,x2);
title('x2(n)');
% x3
L = 51;
x3 = zeros(L,1);
x3(34) = 1.5;
subplot(4,1,3);
stem(300:350,x3);
title('x3(n)');
% x4
L = 11;
x4 = zeros(11,1);
x4(4) = 4.5;
subplot(4,1,4);
stem(-10:0,x4);
title('x4(n)');

% EJERCICIO 2
x = [0; 1; 1; 0; 0; 0] * ones(1,7);
x = x(:);
size(x); % Devuelve la longitud de la señal
figure(2);
stem(0:(length(x)-1),x);
title('x(n) = SUM(k=0:6;delta(n-(6*k+1)) + delta(n-(6*k+2)))');
% Formula:
% x(n) = SUM(k=0:6;delta(n-(6*k+1)) + delta(n-(6*k+2)))
% x(:) nos transforma una matriz (M,N) en (M*N,1)

% EJERCICIO 3
x = [1; 0; 0; 0; 0] * ones(1,10);
x = x(:);
figure(3);
stem(0:49,x);
title('Ejercicio 3');
% Contiene L/P = 50/5 = 10 impulsos