%% Representacion de funciones racionales.

% Representacion de una funcion de transferencia racional
num = [ 0 0 2 4];
den = [1 1.3 7 4];

% Calculo de los residuos, polos y terminos directos de una funcion de
% transferencia racional

num = [2 5 3 6];
den = [1 6 11 6];

[r, p , k] = residue(num,den);

% Obtenemos la funcion racional a partir de los residuos, polos y terminos
% directos.

[num,den] = residue(r,p,k);


%% Respuesta a un escalon unidad.

% step(num,den);
% step(num,den,2);
% intervalo = 0:0.01:3;
% step(num,den,intervalo);

%% Ejemplo1

% ---------------------Respuesta a un escalon unidad -----------------------

%******Respuesta a un escalon unidad de una funcion de transferencia******

%*Introduzca el numerador y el denominador de la funcion de transferencia*


num = [0 0 25];
den = [1 4 25];

%********Introduzca la siguiente orden de respuesta a un escalon*********
t=7;

step(num,den,t);

%**************Introduzca la rejilla y el ttulo de la grafica************
grid;
title('Respuesta a un escalon de G(s)=25/(s^2+4s+25)');


%% Ejemplo2 

%-------------------------Respuesta a un impulso unidad--------------------------

%**********Para obtener la respuesta a un impulso unidad de un sistema de primer
%orden G(s)=1/(s+1), multiplicar s por G(s) y utilizar la orden de respuesta a un
% escalon unidad

%********Introduzca el numerador y el denominador de sG(s)**********

num = [1 0];
den = [1 1];

%*******Introduzca la orden de respuesta a un escalon unidad*********

step(num,den);
grid;
title('Respuesta al impulso unidad de G(s)=1/(s+1)');

%% Ejemplo3

%-------------------------------Respuesta a una rampa-----------------------------

%***********La respuesta a un escalon unidad en rampa se obtiene como la respuesta
%a un escalon unidad de G(s)/s

%*********Introduzca el numerador y el denominador de G(s)/s*********
num = [0 0 0 1];
den = [1 1 1 0];

%********Especifique los instantes de tiempo de calculo (tales como t=0:0.1:7).
%A continuacion introduzca la orden de respuesta a un salto unitario
%c = step(num,den,t);

t = 0:0.01:7;

c = step(num,den,t);

%*******Al representar la respuesta a una rampa, aada a la grafica la entrada de
%referencia. La entrada de referencia es t. Incluya como argumentos de la orden
%plot(t,c,’o’,t,t,’-’)

plot(t,c,'.',t,t,'-');

%*******Introduzca la rejilla, el titulo de la grafica y las etiquetas de los ejes
%x e y

grid;
title('Respuesta a una rampa unitaria del sistema G(s)=1/(s^2+s+1)');
xlabel('t seg');
ylabel('Salida c');


%% ******************** EJERCICIOS ***************************************

% *** 1 ***
% *** H(s) = 1/(s+3)*(s+3)

num = [0 0 1];
den = [1 6 9];

[r,p,k] = residue(num,den)

% *** Respuesta al escalon
figure(1);
step(num,den);

% *** Respuesta al impulso unidad
num = [num 0];


figure(2);


% *** Respuesta a la rampa.



