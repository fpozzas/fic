% Alumno: Daniel Fernández Núñez
function [xn] = idft(X)

N = length(X);
k = 0:N-1;
n = 0:N-1;
f = -1j*(2*pi/N)*n;
F = exp(k'*f);
Finv = inv(F);
xn = Finv * X;
end

