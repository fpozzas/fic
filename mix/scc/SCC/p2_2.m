'Ejemplo 7.4 : Sistema b'
numg = 500*poly([-2 -5 -6]);
deng = poly([0 -8 -10 -12]);

G = tf(numg,deng);

'Comprobacion de estabilidad'
T = feedback(G,1);
polos = pole(T);   
aux = zeros(length(polos),1)>=polos;
if (sum(aux)~=length(aux))
    display('El sistema no es estable');
else
    display('El sistema es estable');
end

'Entrada : escalón'
Kp = dcgain(G);
ess = 1/(1+Kp)

'Entrada : rampa'
numsg = conv(numg,[1 0]);
densg = deng;
sG = tf(numsg,densg);
sG = minreal(sG);
Kv = dcgain(sG);
ess = 1/Kv

'Entrada : parabólica'
nums2g = conv(numg,[1 0 0]);
dens2g = deng;
s2G = tf(nums2g,dens2g);
s2G = minreal(s2G);
Ka = dcgain(s2G);
ess = 1/Ka
pause
