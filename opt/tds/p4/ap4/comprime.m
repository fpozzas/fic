% Alumno: Daniel Fernández Núñez
% G = comprime(F,f0)
function [G] = comprime(F,f0)

G = F.*(abs(F)>f0);

end

