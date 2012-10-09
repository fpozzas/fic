% Alumno: Daniel Fernández Núñez
% Fc = centrarft(F)
% Devuelve la TF centrada a partir
% de la TF (volviendo al tiempo con
% una TF inversa para hacer el
% desplazamiento y haciendo la TF
% de nuevo)
function [Fc] = centrarft(F)

f = ifft2(F);

N = length(f(:,1));
M = length(f(1,:));

n = (0:N-1)' * ones(1,M);
m = (0:M-1)' * ones(1,N);
H = m'+n;
fc = f.*(-1).^(H);
Fc = fft2(fc);
