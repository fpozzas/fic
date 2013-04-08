%% Ejercicio3 :
clc;
clear all;
close all;

% G(s) = 1/(s^3+3s^2+2s).

num = [0 0 0 1];
den = [1 3 2 0];

'Ceros de G(s)'
roots(num)
'Polos de G(s)'
roots(den)

% Construcción del sistema.
sist = tf(num,den);

% Dibujo del lugar geometrico de las raices.
rlocus(sist);

% Calculo del valor de K en el punto de ruptura
[k,p] = rlocfind(sist);
'Valor de K en el punto de ruptura'
k

% Calculo del valor de K en el punto de corte el eje jw
[k,p] = rlocfind(sist);
'Valor de K en el punto de corte con jw'
k

%% Ejercicio4.1 :
clc;
clear all;
close all;

% G(s) = 1/(s^3+4s^2+5s).

num = [0 0 0 1];
den = [1 4 5 0];

'Ceros de G(s)'
roots(num)
'Polos de G(s)'
roots(den)

% Construcción del sistema.
sist = tf(num,den);

% Dibujo del lugar geometrico de las raices.
rlocus(sist);

% Calculo del valor de K en el punto de ruptura
[k,p] = rlocfind(sist);
'Valor de K en el punto de ruptura'
k

% Calculo del valor de K en el punto de corte el eje jw
[k,p] = rlocfind(sist);
'Valor de K en el punto de corte con jw'
k

%% Ejercicio4.2 :
clc;
clear all;
close all;

% G(s) = 1/(s^3+4s^2+5s).

num = [0 0 0 1];
den = [1 6 25 0];

'Ceros de G(s)'
roots(num)
'Polos de G(s)'
roots(den)

% Construcción del sistema.
sist = tf(num,den);

% Dibujo del lugar geometrico de las raices.
rlocus(sist);

% Calculo del valor de K en el punto de ruptura
[k,p] = rlocfind(sist);
'Valor de K en el punto de ruptura'
k

% Calculo del valor de K en el punto de corte el eje jw
[k,p] = rlocfind(sist);
'Valor de K en el punto de corte con jw'
k

%% Ejercicio 4.2 :
clc;
clear all;
close all;

% G(s) = 1/s(s+1)(s+2)(s+3).

num = [0 0 0 1];
den = conv([1 0],conv([1 1],conv([1 2],[1 3])));

'Ceros de G(s)'
roots(num)
'Polos de G(s)'
roots(den)

% Construcción del sistema.
sist = tf(num,den);

% Dibujo del lugar geometrico de las raices.
rlocus(sist);

% Calculo del valor de K en el punto de ruptura
[k,p] = rlocfind(sist);
'Valor de K en el punto de ruptura'
k

% Calculo del valor de K en el punto de corte el eje jw
[k,p] = rlocfind(sist);
'Valor de K en el punto de corte con jw'
k

%% Ejercicio 4.4 :
clc;
clear all;
close all;

% G(s) = 1/s(s+1)(s^2+4s+5).

num = [0 0 0 1];
den = conv([1 0],conv([1 1],[1 4 5]));

'Ceros de G(s)'
roots(num)
'Polos de G(s)'
roots(den)

% Construcción del sistema.
sist = tf(num,den);

% Dibujo del lugar geometrico de las raices.
rlocus(sist);

% Calculo del valor de K en el punto de ruptura
[k,p] = rlocfind(sist);
'Valor de K en el punto de ruptura'
k

% Calculo del valor de K en el punto de corte el eje jw
[k,p] = rlocfind(sist);
'Valor de K en el punto de corte con jw'
k

%% Ejercicio 4.5 :
clc;
clear all;
close all;

% G(s) = 1/s(s+1)(s^2+4s+13).

num = [0 0 0 1];
den = conv([1 0],conv([1 1],[1 4 13]));

'Ceros de G(s)'
roots(num)
'Polos de G(s)'
roots(den)

% Construcción del sistema.
sist = tf(num,den);

% Dibujo del lugar geometrico de las raices.
rlocus(sist);

% Calculo del valor de K en el punto de ruptura
[k,p] = rlocfind(sist);
'Valor de K en el punto de ruptura'
k

% Calculo del valor de K en el punto de corte el eje jw
[k,p] = rlocfind(sist);
'Valor de K en el punto de corte con jw'
k