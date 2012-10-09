% Alumno: Daniel Fernández Núñez
% Apartado 3.2.2 Realzado de bordes

close all;
F = double(imread('lenna512.tif'));

G1 = palto(F,'basicoN');
G2 = palto(F,'elim','mmovil1');
G3 = palto(F,'bordesv',18);

figure;
colormap(gray(256));
subplot(131);
image(G1);
title('Filtrado lineal basico (norte)');
subplot(132);
image(G2);
title('Filtrado lineal por eliminacion');
subplot(133);
image(G3);
title('Filtrado no lineal de detección de bordes');
