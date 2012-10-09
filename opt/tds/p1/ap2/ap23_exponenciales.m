close all;
% Apartado 2
% 2.3 Exponenciales

% EJERCICIO 1
% Representar x(n)=(0.9)^n, en el intervalo n=0:20
% mediante genexp
L = 21;
figure(1);
hold on;
y = genexp(0.9,0,L);
stem(0:20,y);
title('Exponencial x(n)=0.9^n generada por genexp');
% EJERCICIO 2
% Usando el ejemplo del ejercicio 1:
sumgenexp = sum(y)
ecuacion4 = (1 - 0.9^L)/(1 - 0.9)
% EJERCICIO 3
% Simplificando en la parte derecha de la ecuación 5
% alfa*y(n-1) = alfa*alfa^(n-1) = alfa*(alfa^n/alfa) = alfa^n
% luego el desplazamiento en tiempo no cambia el carácter
% de la exponencial
% Comparamos "y(2:L)" y "alfa*y(1:L-1)" 
y1 = genexp(0.9,2,5)
y2 = 0.9*genexp(0.9,1,5)
% Podemos comprobar que son iguales. Se ve que es muy facil desplazar
% una señal exponencial multiplicando o dividiendo por su base

% EJERCICIO 4
% y(n) = x(n)+alfa*y(n-1)
alfa = 0.9;
L = 21;
a = zeros(1,L);
a(1) = 1;
a(2) = -alfa;
b = zeros(1,L);
b(1) = 1;
% Sea x un impulso unidad
x = zeros(1,L);
x(1) = 1;
y=filter(b,a,x);
figure(2);
stem(0:20,y);
title('Ejemplo del ejercicio 1 generado mediante filter');
