% Alumno: Daniel Fernández Núñez
% Apartado 4.1.2 Centrado de la TF

close all;
%f = double(imread('lbh.tif'));
%f = double(imread('lbv.tif'));
%f = double(imread('rect1.tif'));
%f = double(imread('rect2.tif'));
%f = double(imread('rect3.tif'));
%f = double(imread('rect4.tif'));
%f = double(imread('circulo.tif'));

F = fft2(f);
G = escalado(F);
figure;
image(f)
colormap(gray(256));
figure;
subplot(121);
contour(abs(centrarft(G)));
subplot(122);
mesh(abs(centrarft(G)));