% Alumno: Daniel Fernández Núñez
% function [f1,f2,f3,f4,f5,f6,f7] = imgeom(N,M)
% Devuelve las siete imágenes especificadas en el
% enunciado de la práctica con un tamaño NxN y M puntos.
function [f1,f2,f3,f4,f5,f6,f7] = imgeom(N,M)

N = 64;
M = 20;

Nd2 = floor(N/2);
Md2 = floor(M/2);

% f1: linea blanca horizontal
f1 = zeros(N);
f1(Nd2,:) = 255;
% f2: linea blanca vertical
f2 = f1';
% f3: rectangulo blanco (M ancho, N alto) sobre fondo negro
f3 = zeros(N);
f3(:,Nd2-Md2+1:(Nd2-Md2)+M) = 255;
% f4: rectangulo blanco (N ancho, M alto) sobre fondo negro
f4 = f3';
% f5: rectangulo M ancho y 2*M alto
f5 = zeros(N);
f5(Nd2-M+1:(Nd2-M)+2*M,Nd2-Md2+1:(Nd2-Md2)+M) = 255;
% f6: rectangulo 2*M ancho y M alto
f6 = f5';
% f7: circulo radio M
x = (-Nd2+1:Nd2).^2;
x = x'*ones(1,N);
sum = x+x';
f7 = (sum<=M^2)*255;

end

