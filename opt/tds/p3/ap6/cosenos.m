% Alumno: Daniel Fernández Núñez
% cosenos(N,A0,w0,A1,w1)
% x(n) = A0*cos(w0*n) + A1*cos(w1*n)
function [ xn ] = cosenos(N,A0,w0,A1,w1)

n = (0:N-1)';
xn = A0*cos(w0*n) + A1*cos(w1*n);

end

