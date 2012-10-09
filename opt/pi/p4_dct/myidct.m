function [X] = myidct(C)
%[X] = myidct(C)

ncols=length(C(1,:));
% nfilas=length(C(:,1));
% Suponemos que es cuadrada
n = ncols;

% Construcción de U
i = 0:n-1;
j = 0:n-1;
U = sqrt(2/n)*cos(j'*(i+0.5)*pi/n);
U(1,:) = U(1,:)/sqrt(2);
U = U';
% Se verifica que la siguiente operación es la identidad.
%U * U'
X = U * C * U';
end

