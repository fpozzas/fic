% Alumno: Daniel Fernández Núñez
% Apartado 4.1.1 Compresion del margen dinamico

f = double(imread('circulo.tif'));

F = fft2(f);
G = escalado(F);

subplot(121);
contour(abs(fftshift(F)));
subplot(122);
contour(abs(fftshift(G)));