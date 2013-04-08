
%% ******************** EJERCICIOS ***************************
% Falta arreglar lo de las que tienen más polos que ceros.

%% Ejercicio1. 
% *** H(s) = 1/(s+3)*(s+3)

num = [0 0 1];
den = [1 6 9];

[r,p,k] = residue(num,den);

% Polos : p=-3 (polo doble).

% *** Respuesta al escalon.
figure(1);
step(num,den);
grid;
title('Respuesta al escalon de H(s)=1/(s+3)*(s+3)');

% *** Respuesta al impulso unidad
num2 = [num(2:length(num)) 0];

figure(2);
step(num2,den);
grid;
title('Respuesta al impulso unitario de H(s)=1/(s+3)*(s+3)');

% *** Respuesta a la rampa.
num3=[0 num];
den3=[den 0];

figure(3);
step(num3,den3,4);
grid;
title('Respuesta a la rampa de H(s)=1/(s+3)*(s+3)');

%% Ejercicio2.
% H(s)=10/s(s+2)(s+3)(s+3)
den = conv([1 0],conv([1 2],conv([1 3],[1 3])));
num = [zeros(1,length(den)-1) 1]*10;

[r,p,k]=residue(num,den);
% Polos : p1 = 0; p2 = -2; p3= -3 (doble).
% *** Respuesta escalon.
figure(1);
step(num,den,10);
grid;
title('Respuesta al escalon de H(s)=10/s(s+2)(s+3)(s+3)');

%*** Respuesta al impulso unidad.
num2 = [num 0];
den2 = [0 den];
figure(2);
step(num2,den2,10);
title('Respuesta al impulso de H(s)=10/s(s+2)(s+3)(s+3)');

%*** Respuesta a la rampa. 
num3 = [0 num];
den3 = [den 0];
figure(3);
step(num3,den3,10);
title('Respuesta a la rampa de H(s)=10/s(s+2)(s+3)(s+3)');

%% Ejercicio3.
num = [0 0 1];
den = [1 0 9];

[r,p,k]=residue(num,den);
% Polos :

% *** Respuesta escalon.
figure(1);
step(num,den,10);
grid;
title('Respuesta al escalon de H(s)=1/(s*s+9)');

%*** Respuesta al impulso unidad.
num2 = [num 0];
den2 = [0 den];
figure(2);
step(num2,den2,10);
grid;
title('Respuesta al impulso de H(s)=1/(s*s+9)');

%*** Respuesta a la rampa. 
num3 = [0 num];
den3 = [den 0];
figure(3);
step(num3,den3,10);
grid;
title('Respuesta a la rampa de H(s)=1/(s*s+9)');

%% Ejercicio4
den = conv([1 1],[1 1]) + [0 0 9];
num = [0 1 1]; 

[r,p,k]=residue(num,den);
% Polos :

% *** Respuesta escalon.
figure(1);
step(num,den,10);
grid;
title('Respuesta al escalon de H(s)=(s+1)/(s+1)*(s+1)+9');

%*** Respuesta al impulso unidad.
num2 = [num 0];
den2 = [0 den];
figure(2);
step(num2,den2,10);
grid;
title('Respuesta al impulso de H(s)=(s+1)/(s+1)*(s+1)+9');

%*** Respuesta a la rampa. 
num3 = [0 num];
den3 = [den 0];
figure(3);
step(num3,den3,10);
grid;
title('Respuesta a la rampa de H(s)=(s+1)/(s+1)*(s+1)+9');

%% Ejercicio5.
num = [0 1 2]; 
den = [1 7 12]; 
[r,p,k]=residue(num,den);
% Polos :

% *** Respuesta escalon.
figure(1);
step(num,den,10);
grid;
title('Respuesta al escalon de H(s)=(s+2)/(s*s+7s+12)');

%*** Respuesta al impulso unidad.
num2 = [num 0];
den2 = [0 den];
figure(2);
step(num2,den2,10);
grid;
title('Respuesta al impulso de H(s)=(s+2)/(s*s+7s+12)');

%*** Respuesta a la rampa. 
num3 = [0 num];
den3 = [den 0];
figure(3);
step(num3,den3,10);
grid;
title('Respuesta a la rampa de H(s)=(s+2)/(s*s+7s+12)');


%% Ejercicio6.
num = [0 1 1]; 
den = [1 5 6]; 
[r,p,k]=residue(num,den);
% Polos :

% *** Respuesta escalon.
figure(1);
step(num,den,10);
grid;
title('Respuesta al escalon de H(s)=(s+1)/(s*s+5s+6)');

%*** Respuesta al impulso unidad.
num2 = [num 0];
den2 = [0 den];
figure(2);
step(num2,den2,10);
grid;
title('Respuesta al impulso de H(s)=(s+1)/(s*s+5s+6)');

%*** Respuesta a la rampa. 
num3 = [0 num];
den3 = [den 0];
figure(3);
step(num3,den3,10);
grid;
title('Respuesta a la rampa de H(s)=(s+1)/(s*s+5s+6)');

%% Ejercicio7.
num = conv([1 1],[1 1]); 
den = [1 -1 1]; 
[r,p,k]=residue(num,den);
% Polos :

% *** Respuesta escalon.
figure(1);
step(num,den,10);
grid;
title('Respuesta al escalon de H(s)=(s+1)*(s+1)/(s*s-s+1)');

%*** Respuesta al impulso unidad. ( Tiene mas ceros que polos!).
% num2 = [num 0];
% den2 = [0 den];
% figure(2);
% step(num2,den2,10);
% grid;
% title('Respuesta al impulso de H(s)=(s+1)*(s+1)/(s*s-s+1');

%*** Respuesta a la rampa. 
num3 = [0 num];
den3 = [den 0];
figure(3);
step(num3,den3,10);
grid;
title('Respuesta a la rampa de H(s)=(s+1)*(s+1)/(s*s-s+1');

%% Ejercicio8.
num = [1 -1 1];
den = conv([1 1],[1 1]); 


[r,p,k]=residue(num,den);
% Polos :

% *** Respuesta escalon.
figure(1);
step(num,den,10);
grid;
title('Respuesta al escalon de H(s)=(s*s-s+1)/(s+1)*(s+1)');

% %*** Respuesta al impulso unidad. ( Tiene mas ceros que polos!).
% num2 = [num 0];
% den2 = [0 den];
% figure(2);
% step(num2,den2,10);
% grid;
% title('Respuesta al impulso de H(s)=(s*s-s+1)/(s+1)*(s+1)');

%*** Respuesta a la rampa. 
num3 = [0 num];
den3 = [den 0];
figure(3);
step(num3,den3,10);
grid;
title('Respuesta a la rampa de H(s)=(s*s-s+1)/(s+1)*(s+1)');

%% Ejercicio 9.
num = [0 0 0 1]; 
den = conv([1 0],conv([1 2],[1 3])); 
[r,p,k]=residue(num,den);
% Polos :

% *** Respuesta escalon.
figure(1);
step(num,den,10);
grid;
title('Respuesta al escalon de H(s)=1/s(s+2)(s+3)');

%*** Respuesta al impulso unidad.
num2 = [num 0];
den2 = [0 den];
figure(2);
step(num2,den2,10);
grid;
title('Respuesta al impulso de H(s)=1/s(s+2)(s+3)');

%*** Respuesta a la rampa. 
num3 = [0 num];
den3 = [den 0];
figure(3);
step(num3,den3,10);
grid;
title('Respuesta a la rampa de H(s)=1/s(s+2)(s+3)');

%% Ejercicio 10.
num = [0 0 0 10]; 
den = conv([1 3],conv([1 1],[1 1])); 
[r,p,k]=residue(num,den);
% Polos :

% *** Respuesta escalon.
figure(1);
step(num,den,10);
grid;
title('Respuesta al escalon de H(s)=10/(s+1)(s+1)(s+3)');

%*** Respuesta al impulso unidad.
num2 = [num 0];
den2 = [0 den];
figure(2);
step(num2,den2,10);
grid;
title('Respuesta al impulso de H(s)=1/(s+1)(s+1)(s+3)');

%*** Respuesta a la rampa. 
num3 = [0 num];
den3 = [den 0];
figure(3);
step(num3,den3,10);
grid;
title('Respuesta a la rampa de H(s)=1/(s+1)(s+1)(s+3)');

%% Ejercicio 11.
num = 2*[0 0 1 1]; 
den = conv([1 0],[1 1 2]); 
[r,p,k]=residue(num,den);
% Polos :

% *** Respuesta escalon.
figure(1);
step(num,den,10);
grid;
title('Respuesta al escalon de H(s)=2*(s+1)/s(s*s+s+2)');

%*** Respuesta al impulso unidad.
num2 = [num 0];
den2 = [0 den];
figure(2);
step(num2,den2,10);
grid;
title('Respuesta al impulso de H(s)=2*(s+1)/s(s*s+s+2)');

%*** Respuesta a la rampa. 
num3 = [0 num];
den3 = [den 0];
figure(3);
step(num3,den3,10);
grid;
title('Respuesta a la rampa de H(s)=2*(s+1)/s(s*s+s+2)');



%% Ejercicio 12.
den = conv([1 1],conv([1 1],[1 1]));
num = [zeros(1,length(den)-1) 1]; 

[r,p,k]=residue(num,den);
% Polos :

% *** Respuesta escalon.
figure(1);
step(num,den,10);
grid;
title('Respuesta al escalon de H(s)=1/(s+1)^3');

%*** Respuesta al impulso unidad.
num2 = [num 0];
den2 = [0 den];
figure(2);
step(num2,den2,10);
grid;
title('Respuesta al impulso de H(s)=1/(s+1)^3');

%*** Respuesta a la rampa. 
num3 = [0 num];
den3 = [den 0];
figure(3);
step(num3,den3,10);
grid;
title('Respuesta a la rampa de H(s)=1/(s+1)^3');