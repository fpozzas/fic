% Alumno: Daniel Fernández Núñez
function [ x1 ] = deconvol();
Ly = 8;
L1 = 8;
L2 = 8;
y = [57,63,66,69,64,67,63,64]';
x2 = [1,1,0,0,0,0,0,1]';
% Si y = x1 (*) x2
% Y = X1*X2 -> X1=Y/X2
Y = dft(y,Ly,L1);
X2 = dft(x2,L2,L1);
X1 = Y./X2;
x1 = round(idft(X1));