% Alumno: Daniel Fernández Núñez
% Apartado 5. Convoluciones lineales vs circulares

close all;
% Caso 1
L1 = 15;
L2 = 15;
N = 20;
convol(L1,L2,N);
% Caso 2
L1 = 10;
L2 = 2;
N = 10;
convol(L1,L2,N);
% El minimo N para que las dos convoluciones
% sean iguales:
convol(L1,L2,L1+L2-1);