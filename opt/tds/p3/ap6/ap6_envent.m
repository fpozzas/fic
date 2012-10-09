% Alumno: Daniel Fernández Núñez
% Apartado 6. Enventanado

close all;
% Caso 1
N = 256;
L = 100;
A0 = 3;
A1 = 0.4;
w0 = 2*pi/15;
w1 = pi/5;
ventanas(N,L,A0,A1,w0,w1);

% Caso 2
N = 256;
L = 50;
A0 = 1;
A1 = 0.75;
w0 = 2*pi/15;
w1 = pi/5;
ventanas(N,L,A0,A1,w0,w1);