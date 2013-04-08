
%% Simplificacion del diagrama de bloques P7.9
% G1
numg1 = poly([-7]);
deng1 = poly([0 -4 -8 -12]);
% G2
numg2 = 5*poly([-9 -13]);
deng2 = poly([-10 -32 -64]);
% H1 
numh1 = [10];
denh1 = [1];
% H2 
numh2 = [0 1];
denh2 = [1 3];
% Construccion de los LTI
G1 = tf(numg1,deng1);
G2 = tf(numg2,deng2);
H1 = tf(numh1,denh1);
H2 = tf(numh2,denh2);

% Simplificacion 1 : Realimentacion del final (10)
G3 = feedback(G2,H1);
% Simplificacion 2 : En serie
G4 = series(G1,G3);
% Simplificacion 3 : Realimentacion 1/(s+3)
Ge = feedback(G4,H2);

% Estabilidad del sistema :
T = feedback(Ge,1);
polos = pole(T,1);

aux = zeros(length(polos),1)>=polos;
if (sum(aux)~=length(aux))
    display('El sistema no es estable');
else
    display('El sistema es estable');
end

% Tipo del sistema
G = minreal(Ge);
polosG = pole(G);
tipo = sum(polosG==zeros(length(polosG),1));
display('Tipo del sistema ... : ');
display(tipo);


%% Calcular las constantes Kp, Kv y Ka.
% Kp
Kp = dcgain(G)

% Kv
sG = 's'*G;
Kv = dcgain(sG)

% Ka
s2G='s'*sG;
Ka = dcgain(s2G)


%% Error en estado estable.
% Entrada : 30.u(t)
display('Error en estado estable para un escalon ');
ess = 1/(1+Kp)

% Entrada : 30.t.u(t)
display('Error en estado estable para una rampa ');
ess = 1/Kv

% Entrada : 30.t^2.u(t)
display('Error en estado estable para una parabola ');
ess = 1/Ka
