% Alumno: Daniel Fernández Núñez
% ventanas(N,L,A0,A1,w0,w1)
function [ ] = ventanas(N,L,A0,A1,w0,w1)

xn = cosenos(N,A0,w0,A1,w1);
% Ventana rectangular
vrect = xn(1:L);
Vrect = abs(dft(vrect,L,N));
% Ventana de Hamming
vhamm = xn(1:L) .* win_hamming(L);
Vhamm = abs(dft(vhamm,L,N));
% Dibujos
figure;
hold on;

subplot(211);
semilogy(0:2*pi/N:2*pi*(N-1)/N,Vrect);
title('Ventana rectangular');
axis([0 2*pi ylim]);

subplot(212);
semilogy(0:2*pi/N:2*pi*(N-1)/N,Vhamm);
title('Ventana de Hamming');
axis([0 2*pi ylim]);
end

