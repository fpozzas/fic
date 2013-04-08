clc;
clear all;
close all;
% Ejemplo 1 del tema 4 : G(s) = 1/[s(s+10)]
num = [0 0 1];
den = [1 10 0];

'Ceros de G(s)'
'En este caso, G(s) no tiene ceros'
'Polos de G(s)'
roots(den)
'Puntos de desdoblamiento : Cálculo analítico'
% K=-1/G[sigma] ----> dk/dsigma = 0 ----> ecuacion -2.sigma-10=0
sigma=roots([-2 -10])
'El valor de K en el punto de desdoblamiento : Cálculo Analítico'
% Sustituyendo en la ecuacion sigma, por lo obtenido en el paso anterior :
k=-sigma*(sigma+10) 
'Dibujo del LGR'
sist = tf(num,den);
rlocus(sist);
[k,p]=rlocfind(sist);
'Obteniendo sigma a través de rlocfind'
sigma
'Obteniendo K a través de rlocfind'
k