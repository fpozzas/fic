% Alumno: Daniel Fernández Núñez
% Apartado 3.1.1 Negativo

% Curva de la transformacion
f = 0:255;
g = negativo(f);
figure;
subplot(211);
plot(0:255,f);
axis([0 255 0 255]);
title('Curva de transformación: vector f');
subplot(212);
plot(0:255,g);
axis([0 255 0 255]);
title('Curva de transformación: vector T(f)');

% Imagen transformada
F = double(imread('lenna512.tif'));
G = negativo(F);
figure;
subplot(121);
image(F);
colormap(gray(256));
title('Imagen original');
subplot(122);
image(G);
colormap(gray(256));
title('Negativo');

figure;
subplot(211);
hist(F(:));
title('Histograma de la original');
subplot(212);
hist(G(:));
title('Histograma de la transformada');


