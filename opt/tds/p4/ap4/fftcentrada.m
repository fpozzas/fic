% Alumno: Daniel Fernández Núñez
% Fc = fftcentrada(f)
% Devuelve la TF centrada a partir de la
% matriz temporal.
function [Fc] = fftcentrada(f)

N = length(f(:,1));
M = length(f(1,:));

n = (0:N-1)' * ones(1,M);
m = (0:M-1)' * ones(1,N);
H = m'+n;
fc = f.*(-1).^(H);
Fc = fft2(fc);
