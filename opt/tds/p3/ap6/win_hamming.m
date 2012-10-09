% Alumno: Daniel Fernández Núñez
% win_hamming(L)
function [ wn ] = win_hamming(L)

n = (0:L-1)';
wn = 0.54 - 0.46*cos(2*pi*n/(L-1));

end

