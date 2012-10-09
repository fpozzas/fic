function [ mse,Qs,Qmin,rk,tk ] = cunif(L,S)
% [ mse,Qs,Qmin,rk,tk ] = cunif(L,S)
% Cuantificador uniforme
% Entrada:
% - L : niveles del cuantificador
% - S : señal a cuantificar
% Salida:
% - MSE : mean square error
% - Qs : secuencia cuantificada a L niveles
% - Qmin : valores para el array rk
% - rk
% - tk

% Paso del cuantificador
q=(max(S)-min(S))/L
tk=(min(S):q:max(S))
rk=tk+(q/2)
rk=rk(1:end-1);
% Señal cuantificada
Q=fix(S./q);
Qmin=Q-min(Q)+1;
Qmin=Qmin-(Qmin==(L+1));
Qs=rk(Qmin);
% MSE
mse = mean((S-Qs).^2);
end

