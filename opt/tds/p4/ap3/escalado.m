% Alumno: Daniel Fern�ndez N��ez
% G = escalado(F)
function [G] = escalado(F)

F = double(F);
c = 255/max(log10(1+F(:)));
G = c*log10(1+abs(F));

end

