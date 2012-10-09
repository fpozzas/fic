% Alumno: Daniel Fernández Núñez
% Apartado 3.1.2 Modificacion del constraste

F = double(imread('lenna512.tif'));
f = 0:255;


figure;
g = contrast(f,128,128,0,255);
G = contrast(F,128,128,0,255);
subplot(221);
hist(F(:));
title('Histograma original');
subplot(222);
hist(G(:));
title('Histograma contrastada');
subplot(223);
plot(g);
axis([0 255 0 255]);
title('Curva de transformacion');
subplot(224);
image(G);
colormap(gray(256));
title('Imagen contrastada');

figure;
g = contrast(f,20,235,40,215);
G = contrast(F,20,235,40,215);
subplot(221);
hist(F(:));
title('Histograma original');
subplot(222);
hist(G(:));
title('Histograma contrastada');
subplot(223);
plot(g);
axis([0 255 0 255]);
title('Curva de transformacion');
subplot(224);
image(G);
colormap(gray(256));
title('Imagen contrastada');

figure;
g = contrast(f,40,215,20,235);
G = contrast(F,40,215,20,235);
subplot(221);
hist(F(:));
title('Histograma original');
subplot(222);
hist(G(:));
title('Histograma contrastada');
subplot(223);
plot(g);
axis([0 255 0 255]);
title('Curva de transformacion');
subplot(224);
image(G);
colormap(gray(256));
title('Imagen contrastada');