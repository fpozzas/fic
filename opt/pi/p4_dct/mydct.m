function [C] = mydct(X)
%[Y] = mydct(X)

ncols=length(X(1,:));
% nfilas=length(X(:,1));
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
C = U' * X * U;
end

