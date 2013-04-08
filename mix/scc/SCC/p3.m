%% Ejercicio1 :
clc;
clear all;
close all;
% G(S) = (s^2+1)/s(s+2)
num = [1 0 1];
den = [1 2 0];

'Ceros de G(s)'
roots(num)
'Polos de G(s)'
r=roots(den)

% C�lculo anal�tico :
%---------------------
'Puntos de desdoblamiento : C�lculo anal�tico'
% k = -1/G[sigma] ----> dk/dsigma = 0 
% ----> dk/dsigma = -(-2sigma^2+2sigma+2)/ (sigma^2+1)=0
ec = [1 -1 -1];
ptos = roots(ec);
sigma=[];
for i=1:length(ptos)
    % Comprobamos que est� en el intervalo
    if(ptos(i)<r(1) && ptos(i)>r(2))
        sigma = [sigma; ptos(i)];
    end
end
'Sigma : C�lculo anal�tico'
sigma
'K en el punto de desdoblamiento : C�lculo anal�tico'
K = -(sigma.^2+2.*sigma)./(sigma.^2.+1)

% C�lculo mediante rlocfind :
%----------------------------
% Construccion de la grafica del LGR
sist = tf(num,den);
% Dibujamos el LGR
rlocus(sist);
title('Lugar geometrico de las raices');
[k,p]=rlocfind(sist);
'Sigma mediante rlocfind'
real((p(1)+p(2))/2)
'K mediante rlocfind'
k


%% Ejercicio2.1 :
num = [0 1 2];
den = [1 2 3];

'Ceros de G(s)'
c=roots(num)
'Polos de G(s)'
roots(den)

% C�lculo anal�tico :
%---------------------
'Ptos de desdoblamiento : C�lculo Anal�tico'
ec = [1 4 1];
ptos = roots(ec);
sigma = [];
for i=1:length(ptos)
    % Comprobamos que est� en el intervalo
    if(ptos(i)<c(1))
        sigma = [sigma; ptos(i)];
    end
end
'Sigma : C�lculo anal�tico'
sigma
'K en el punto de desdoblamiento : C�lculo anal�tico'
K = -(sigma.^2+2.*sigma+3)./(sigma+2)


% C�lculo mediante rlocfind :
%----------------------------
% Construccion de la grafica del LGR
sist = tf(num,den);
% Dibujamos el LGR
rlocus(sist);
title('Lugar geometrico de las raices');
[k,p]=rlocfind(sist);
'Sigma mediante rlocfind'
real((p(1)+p(2))/2)
'K mediante rlocfind'
k


%% Ejercicio2.2 :
num = [0 1 2];
den = [1 0 0];

'Ceros de G(s)'
c=roots(num)
'Polos de G(s)'
roots(den)

% C�lculo anal�tico :
%---------------------
'Ptos de desdoblamiento : C�lculo Anal�tico'
ec = [1 4 0];
ptos = roots(ec)

sigma = [];
for i=1:length(ptos)
    % Comprobamos que est� en el intervalo
    if(ptos(i)<c(1))
        sigma = [sigma; ptos(i)];
    end
end
'Sigma : C�lculo anal�tico'
sigma
'K en el punto de desdoblamiento : C�lculo anal�tico'
K = -(sigma.^2)./(sigma+2)

% C�lculo mediante rlocfind :
%----------------------------
% Construccion de la grafica del LGR
sist = tf(num,den);
% Dibujamos el LGR
rlocus(sist);
title('Lugar geometrico de las raices');
[k,p]=rlocfind(sist);
'Sigma mediante rlocfind'
real((p(1)+p(2))/2) 
'K mediante rlocfind'
k


%% Ejercicio2.3 :
clc;
clear all;
close all;

num = [0 1 1.4 0.24];
den = [1 0 1 0];

'Ceros de G(s)'
c=roots(num)
'Polos de G(s)'
d=roots(den)
% C�lculo anal�tico :
%---------------------
'Ptos de desdoblamiento : C�lculo Anal�tico'
ec = [1 2.8 -0.28 0 0.24];
ptos = roots(ec);
sigma = [];
for i=1:length(ptos)
    % Comprobamos que est� en el intervalo
    if(ptos(i)<c(1) || ptos(i)>c(2) && ptos(i)<d(1))
        sigma = [sigma; ptos(i)];
    end
end
'Sigma : C�lculo anal�tico'
sigma
'K en el punto de desdoblamiento : C�lculo anal�tico'
K = -(sigma.^3+sigma)./(sigma.^2 + 1.4.*sigma + 0.24)


% C�lculo mediante rlocfind :
%----------------------------
% Construccion de la grafica del LGR
sist = tf(num,den);
% Dibujamos el LGR
rlocus(sist);
title('Lugar geometrico de las raices');
[k,p]=rlocfind(sist);
'Sigma mediante rlocfind'
real((p(1)+p(2))/2) 
'K mediante rlocfind'
k

