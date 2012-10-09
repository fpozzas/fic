% Alumno: Daniel Fern�ndez N��ez
% Apartado 3.1.3 Compresi�n del rango din�mico

F = double(imread('escalado.tif'));
G = escalado(F);
figure;
subplot(131);
plot(escalado(0:255));
axis([0 255 0 255]);
title('Curva de transformacion');
subplot(132);
image(F);
colormap(gray(256));
title('Imagen original');
subplot(133);
image(G);
colormap(gray(256));
title('Imagen transformada');
