% Apartado 2.2.
% Importancia de la fase de la DFT

L=10;
N=32;
xn = xn_triangular(L);
xn = [xn ; zeros(N-length(xn),1)];
X = dft(xn,N,N);
xmn = idft(abs(X));

figure;
hold on;
subplot(211);
stem(xn);
subplot(212);
stem(round(real(xmn)));