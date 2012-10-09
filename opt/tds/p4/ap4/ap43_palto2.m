% Alumno: Daniel Fernández Núñez
% Apartado 4.3 Filtrado paso alto

% Ruido impulsivo
close all;
%f = double(imread('lenna512.tif'));
f = double(imread('lenna128.tif'));

figure;
subplot(121);
image(f);
title('Imagen original');
colormap(gray(256));

F = fft2(f);
size(F)
G = fpalto2(F,25);
g = ifft2(G);
subplot(122);
image(real(g));
title('Imagen filtrada');
colormap(gray(256));

figure;
subplot(121);
contour(abs(centrarft(escalado(F))));
title('F original');
subplot(122);
contour(abs(centrarft(escalado(G))));
title('F filtrada');