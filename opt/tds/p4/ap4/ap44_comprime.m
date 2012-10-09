% Alumno: Daniel Fernández Núñez
% Apartado 4.4 Compresión de imágenes

close all;
f = double(imread('lenna512.tif'));
%f = double(imread('lenna128.tif'));

figure;
subplot(121);
image(f);
title('Imagen original');
colormap(gray(256));

F = fft2(f);
nnz(F)
G = comprime(F,10000);
nnz(G)
g = ifft2(G);
subplot(122);
image(real(g));
title('Imagen filtrada');
colormap(gray(256));
