% Apartado  3.1. Secuencias de prueba

N=100;
L=100;
% El valor de k0 para w0 = pi/2
w0 = pi/2;
f = w0/(2*pi);
k0 = f*N;
% k0 = N/4;
convfrec(L,N,k0);