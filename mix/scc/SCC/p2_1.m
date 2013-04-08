'Practica 2 : Sistema de control de un UFSS' %Etiqueta para mostrar
'Solucion con los comandos <series>, <parallel>, y <feedback>'

% Numerador y denominador de G1
numg1 = [-1];
deng1 = [1];
% Numerador y denominador de G2
numg2 = [0 2];
deng2 = [1 2];
% Numerador y denominador de G3
numg3 = -0.125*[1 0.435];
deng3 = conv([1 1.23],[1 0.266 0.0169]);
% Numerador y denominador de H
numh1 = [-1 0];
denh1 = [0 1];

% Construccion de los LTI
G1 = tf(numg1,deng1);
G2 = tf(numg2,deng2);
G3 = tf(numg3,deng3);

H1 = tf(numh1,denh1);

% Simplificaciones
G4 = series(G2,G3);
G5 = feedback(G4,H1);

Ge = series(G1,G5);
'T(s) utilizando los comandos <series>, <parallel>, y <feedback>'
T = feedback(Ge,1);
display(T);