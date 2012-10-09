% Alumno: Daniel Fernández Núñez
% Apartado 3.2.1 Filtrado de ruido

% Ruido impulsivo
close all;
F = double(imread('lenna512.tif'));
p = rand(size(F))>0.05;
% Ponemos a cero los lugares del ruido
F = F.*p;
% Ponemos a 0 o 255 los lugares del ruido
F = F + not(p).*(rand(size(F))>0.5)*255;
figure;
subplot(121);
image(F);
title('Ruido impulsivo');
colormap(gray(256));

L=3;
G = pbajo(F,L,'mmovil1');
%G = pbajo(F,L,'mmovil2');
%G = pbajo(F,L,'mmovil3');
%G = pbajo(F,L,'mediana');
%G = pbajo(F,3,'outrange',65);
subplot(122);
image(G);
title('Filtrado del ruido impulsivo');
colormap(gray(256));

% Ruido gaussiano
F = double(imread('lenna512.tif'));
F = 16*randn(size(F))+F;
figure;
subplot(121);
image(F);
title('Ruido gaussiano');
colormap(gray(256));

L=3;
%G = pbajo(F,L,'mmovil1');
%G = pbajo(F,L,'mmovil2');
%G = pbajo(F,L,'mmovil3');
%G = pbajo(F,L,'mediana');
G = pbajo(F,3,'outrange',10);
subplot(122);
image(G);
title('Filtrado del ruido gaussiano');
colormap(gray(256));