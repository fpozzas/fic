% Alumno: Daniel Fernández Núñez
% [ xd,fs ] = codifica(wav,f0)
function [ xd,fs ] = codifica(wav,f0);
N = 8192;
% Obtenemos la informacion del audio
[xn,fs,nbits] = wavread(wav);
L = length(xn);
% Desplazamiento
k0 = N*f0/fs;
n = (0:L-1)';
dn = cos((2*pi/N)*k0*n);
xd = xn.*dn;
% Dibujos
figure;
hold on;

subplot(211);
plot(0:fs/N:fs*(N-1)/N,abs(fft(xn,N)));
title('TF del audio original');
axis([0 fs ylim]);

subplot(212);
plot(0:fs/N:fs*(N-1)/N,abs(fft(xd,N)));
title('TF del audio codificado');
axis([0 fs ylim]);

end

