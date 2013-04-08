%% Controlador I:

% ESTA MAL CORREGIRLO TODO. MIRAR ADEMAS LA LONGITUD DE NUM Y DEN
% Definicion de la planta
% Valor de k para el controlador P
k = 92.89;
% Punto donde se cortan
pto = -0.9360 + 3.0280i;

num = [0 0 0 1];
den = conv([1 1],conv([1 2],[1 10]));
numI = num*k;
denI = conv ([1 0],den);
sistema = tf(numI,denI)


% Lugar geometrico de las raices
figure(1);
rlocus(sistema);


% Calculo del porcentaje de sobrepaso de los polos, 
wn = abs(pto);
wd = abs(imag(pto));
alfa = abs(real(pto));
r=alfa/wn;
theta = acos(r);
'Porcentaje de sobrepaso'
os = exp(-pi*r/sqrt(1-r*r))*100
'Tiempo de pico'
Tp = pi/wd
'Tiempo de asentamiento'
Ta = 4/alfa



% Error en estado estable 
'Error en estado estable'
kp = k / 0*1*2*10;
e = 1 /(1+kp)

numIH = k*denI;
denIH = conv(denI,denI + [zeros(1,length(denI)-1) k]);
tf(numIH,denIH)

figure(2);
step(numIH,denIH);