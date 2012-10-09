% Alumno: Daniel Fernández Núñez
% G = negativo(F)
function [G] = negativo(F)

F = double(F);
T = 255:-1:0;
G = T(F+1);

end

