%% Controlador I (2ª parte)

% Revisar en teoría debería tender a 1

% Definicion de la planta
numI = [0 0 0 0 1];
denI = conv([1 0],conv([1 1],conv([1 2],[1 10])));

sistema = tf(numI,denI)
% Especificacion
os = 40; % en tanto por ciento
' Angulo (en radianes)'
theta = atan(-pi/log(os/100)) 
' Angulo en grados '
ang = theta*360 / (2 * pi)
' r = cociente de amortiguamiento '
r = cos(theta)

% Dibujo del lgr
figure(1);
title('Lugar geometrico de las raices');
rlocus(sistema)
hold on;
x = -50:0.01:5;
y = -tan(theta).*x; 
plot(x,y,'r-');
hold off;
pause;
[k,polos] = rlocfind(sistema);
' Punto del lgr donde se satisface la especificacion '
polos
' Valor de k que da lugar a dichos polos '
k

% Caracteristicas
wn = abs(polos(2));
wd = wn * sqrt(1-r*r);
alfa = r*wn;

'Tiempo de pico '
tp = pi/wd

'Tiempo de asentamiento'
ta = 4/alfa

'Error en estado estable'
kp = k/(0*1*2*10);
e = 1/(1+kp)

% Respuesta a la entrada escalon
% H(s) = kG(s)/1+kG(s)
numH = k*num;
denH = [zeros(1,length(den)-1) k] + den;
tf(numH,denH)
figure(2);
title('Respuesta al impulso');
step(numH,denH)
grid;