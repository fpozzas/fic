%
%% Cuantificador uniforme
%%%%%%%%%%%%%%%%%%%%%%%%%

L = 3;
S = [-1.4 -1.2 -1.15 -0.1 0.21 0.36 0.97 1.04 1.56 1.71];

[mse,Qs,Qmin,rk,tk]=cunif(L,S);
%
%% Resultados
%%%%%%%%%%%%%
disp('Cuantificador uniforme');
disp('----------------------');
S
Qs
mse


