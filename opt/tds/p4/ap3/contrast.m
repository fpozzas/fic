% Alumno: Daniel Fernández Núñez
% G = contrast(F,r1,r2,s1,s2)
function [G] = contrast(F,r1,r2,s1,s2)

F = double(F);
if (s1==0)
    T = zeros(1,length(0:r1));
else
    T = 0:s1/r1:s1;
end;
if (r1==r2)
    T = T;
else
    T = [T s1+(s2-s1)/(r2-r1):(s2-s1)/(r2-r1):s2];
end;
if (s2==255)
    T = [T ones(1,length(r2+1:255))*255];
else
    T = [T s2+(255-s2)/(255-r2):(255-s2)/(255-r2):255];
end;

G = T(F+1);

end

