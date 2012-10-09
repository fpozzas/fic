% Alumno: Daniel Fernández Núñez
% G = belimina(F)
function [] = belimina(f)

close all;
f = double(f);
A = 256;
w1 = pi/4;
w2 = pi/4;
N = 256;
M = 256;

n = (0:N-1)' * ones(1,M) * w1;
m = (0:M-1)' * ones(1,N) * w2;
alfa = m'+n;
n = A*sin(alfa);

figure;
subplot(121);
image(n);
subplot(122);
N=fft2(n);
mesh(abs(escalado(centrarft(N))));

figure;
subplot(121);
g = f+n;
image(g);
title('Imagen con ruido coherente');
% Filtrado paso bajo
G = fft2(g);
G = fpbajo2(G,43.84);
f = ifft2(G);
subplot(122);
image(real(f));
title('Imagen reconstruida');
colormap(gray(256));

end

