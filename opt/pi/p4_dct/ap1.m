%
%% Apartado 1
%%%%%%%%%%%%%
X = ones(8)*128
C = mydct(X)
% Para representar X de forma completa, sólo necesitariamos c(0,0)

Xaleat = round(rand(8)*255)
Caleat = mydct(Xaleat)
% El porcentaje de energia de c(0,0) es mucho mayor que el que representa
% c(7,7)
