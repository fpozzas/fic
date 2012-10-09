% Alumno: Daniel Fernández Núñez
% G = fpbajo2(F,d)
function [G] = fpalto2(F,d)

N = length(F(:,1));
M = length(F(1,:));

x = (-floor(N/2)+1:floor(N/2)).^2;
x = x'*ones(1,M);
sum = x+x';
H = (sum>d^2);
%subplot(221);
%contour(abs(H));
H = centrarft(H);
%subplot(222);
%contour(abs(H));

G = F.*H;

end

