function [ mse,Qs,Qmin ] = cunif(L,S)
% Cuantificador uniforme
% Entrada:
% - L : niveles del cuantificador
% - S : se�al a cuantificar
% Salida:
% - MSE : mean square error
% - Qs : secuencia cuantificada a L niveles

% Paso del cuantificador
q=(max(S)-min(S))/L;
tk=(min(S):q:max(S));
rk=tk+q/2;
% Para que el m�ximo no se nos vaya al nivel L+1:
%rk(L+1)=rk(L);
% Se�al cuantificada
Q=fix(S./q);
Qmin=Q-min(Q)+1;
Qmin=Qmin-(Qmin==(L+1));
Qs=rk(Qmin);
% MSE
mse = mean((S-Qs).^2);
end

