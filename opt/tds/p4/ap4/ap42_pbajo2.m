% Alumno: Daniel Fernández Núñez
% Apartado 4.2 Filtrado paso bajo

% Ruido impulsivo
close all;
%f = double(imread('lenna512.tif'));
f = double(imread('lenna128.tif'));
p = rand(size(f))>0.01;
% Ponemos a cero los lugares del ruido
f = f.*p;
% Ponemos a 0 o 255 los lugares del ruido
f = f + not(p).*(rand(size(f))>0.5)*255;
figure;
subplot(121);
image(f);
title('Ruido impulsivo');
colormap(gray(256));

F = fft2(f);
size(F)
G = fpbajo2(F,65);
g = ifft2(G);
subplot(122);
image(real(g));
title('Filtrado del ruido impulsivo');
colormap(gray(256));

figure;
subplot(121);
contour(abs(centrarft(escalado(F))));
title('F original');
subplot(122);
contour(abs(centrarft(escalado(G))));
title('F filtrada');