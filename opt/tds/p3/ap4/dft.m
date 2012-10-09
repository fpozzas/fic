% Alumno: Daniel Fernández Núñez
function [X] = dft(xn,L,N)

k = 0:N-1;
n = 0:L-1;
f = -1j*(2*pi/N)*n;
F = exp(k'*f);
X = F * xn;
end

