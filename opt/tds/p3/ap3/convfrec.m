% Alumno: Daniel Fernández Núñez
% convfrec(L,N,k0)
function [ ] = convfrec(L,N,k0)

n = (0:L-1)';
% TF de la sinc
xn = sinc((n-round(L/2))/10);
X = dft(xn,L,N);
% TF de la sinc desplazada
xn_d = xn.*(exp(1j*(2*pi/N)*k0*n));
X_d = dft(xn_d,L,N);
% Dibujos
figure;
hold on;

subplot(211);
plot(0:2*pi/N:2*pi*(N-1)/N,abs(X));
title('TF de la sinc');
axis([0 2*pi ylim]);

subplot(212);
plot(0:2*pi/N:2*pi*(N-1)/N,abs(X_d));
title('TF de la sinc desplazada en k0');
axis([0 2*pi ylim]);
end

