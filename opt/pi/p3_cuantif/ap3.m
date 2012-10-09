%
%% Imágenes
%%%%%%%%%%%
clear all;
close all;
L = 8;

img = double(imread('lenna512.tif'));
%img = double(imread('airfield512.tif'));

figure(1);
image(img);
colormap(gray(256));
title('Original');

cols = length(img(1,:));
filas = length(img(:,1));
S = img(:);
S = S';
[mse_unif,Qunif]=cunif(L,S);
figure(2);
image(reshape(Qunif,cols,filas));
colormap(gray(256));
title('Uniforme');

[mse_lloyd,Qlloyd]=clloyd(L,S);
figure(3);
image(reshape(Qlloyd,cols,filas));
colormap(gray(256));
title('Lloyd-Max');

mse_unif
mse_lloyd