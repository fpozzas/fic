%% Práctica final de SCC :
%% Controlador Adelanto - Retardo
function [kADRE] = controladorAR(sist)

%% Información del tipo de controlador
disp('------------------------');
disp('  CONTROLADOR TIPO AR   ');
disp('------------------------');
disp('                    ');

[numgpc, dengpc] = tfdata(sist);
numgp = numgpc{1};
dengp = dengpc{1};

polos = roots(dengp);
polosEnCero = (polos==0);
tipo = sum(polosEnCero);

disp(['Tipo de la planta :' num2str(tipo)]);
disp(' ');
if(tipo~=0 && tipo~=1)
    disp('Error : El tipo de la planta no es 0 ó 1');
    return;
end

%% Petición de parámetros
% Par de parámetros
disp('Parámetros :               ');
disp('1 : Porcentaje de sobrepaso - Tiempo de pico');
disp('2 : Porcentaje de sobrepaso - Tiempo de asentamiento');
disp('3 : Tiempo de pico - Tiempo de asentamiento');

disp('                                                ');
par = input('Introduzca el par de parámetros a fijar: ');
disp('                                                ');

while(par~=1 && par~=2 && par~=3)
   parametro1 = input('Introduzca 1,2 ó 3: ');
   disp('             ');
end

switch par
    case 1
        os = input('Introduzca un valor para el porcentaje de sobrepaso(0-100%): ');
        disp(' ');
        tpico = input('Introduzca un valor para el tiempo de pico: ');
    case 2
        os = input('Introduzca un valor para el porcentaje de sobrepaso(0-100%): ');
        disp(' ');
        tasent = input('Introduzca un valor para el tiempo de asentamiento: ');
    case 3
        tpico = input('Introduzca un valor para el tiempo de pico: ');
        disp(' ');
        tasent = input('Introduzca un valor para el tiempo de asentamiento: ');
end
disp(' ');

% Error en estado estable para la entrada : escalón/rampa
switch tipo
    case 0
        error = input('Introduzca el error en estado estable para un escalón: ');
    case 1
        error = input('Introduzca el error en estado estable para una rampa: ');
end
%Posicion del cero de retardo y el polo de adelanto
display(' ');
ceroRE = input('Introduzca la posición del cero de la parte de retardo (<0): ');
display(' ');
poloAD = input('Introduzca la posición del polo de la parte de adelanto (<0 y alejado del origen): ');
display(' ');



%% Cálculo de la función de transferencia del controlador
% Determinar el polo dominante deseado
switch par
    case 1 % Porcentaje de sobrepaso - Tiempo de pico
        % os => tita -> r
        tita = atan(-pi/log(os/100));
        r = cos(tita);
        % wd 
        wd = pi/tpico;
        % wd + r => wn -> alfa
        wn = wd/(sqrt(1-r*r));
        alfa = wn*r;
        
    case 2 % Porcentaje de sobrepaso - Tiempo de asentamiento
        % os => tita -> r
        tita = atan(-pi/log(os/100));
        r = cos(tita);
        % alfa
        alfa = 4/tasent;
        % alfa + r => wn -> wd
        wn = alfa/r;
        wd = wn*sqrt(1-r*r);
        
    case 3 % Tiempo de pico - Tiempo de asentamiento
        % wd
        wd = pi/tpico;
        % alfa
        alfa = 4/tasent;
end
%Posicion del polo dominante deseado
polo = -alfa+i*wd

%Cálculo de los parámetros restantes
switch par
    case 1 % Porcentaje de sobrepaso - Tiempo de pico
        tasent = 4/alfa;
    case 2 % Porcentaje de sobrepaso - Tiempo de asentamiento
        tpico = pi/wd;
    case 3 % Tiempo de pico - Tiempo de asentamiento
        wn = sqrt(wd*wd + alfa*alfa);
        r = alfa/wn;
        os = exp(-pi*r/sqrt(1-r*r))*100;
        tita = acos(r);
end

% Situacion inicial
rlocus(sist);
hold on
limites = axis;
x = [limites(1):0.1:limites(2)];
y = tan(pi-tita)*x;
plot(x,y,'g-');
title('LGR de la planta antes de añadirle controladores');
pause
[k,p] = rlocfind(sist)
close

sistK = series(tf([k],[1]),sist);
sistK = minreal(sistK);

switch tipo
    case 0
        kp=dcgain(sistK);
        %Revisar el nombre
        ess = 1/(1+kp);
    case 1
        sistKs = series(tf([1 0],[1]),sistK);
        sistKs = minreal(sistKs);
        kv = dcgain(sistKs);
        ess = 1/kv;
end



%CALCULO DE LA PARTE DE ADELANTO : ENCONTRAR EL CERO LEAD

%Calculamos la suma de las fases de todas las titas teniendo en cuenta el
%polo de la parte de adelanto introducido por teclado
ctrlPoloA = tf([1],[1 -poloAD]);
sistPoloA = series(sist,ctrlPoloA);
[numgp, dengp] = tfdata(sistPoloA,'v');

suma_fases = angle(polyval(numgp,polo)/polyval(dengp,polo));
fi_cero= pi-suma_fases;

if(fi_cero>(pi/2))
    ceroAD = abs(real(polo) - imag(polo)/tan(fi_cero));
else
    ceroAD = abs(real(polo) + imag(polo)/tan(pi-fi_cero));
end


% Controlador de ADELANTO -> Se añade al sistema
display('Controlador de ADELANTO');
AD = tf([1 ceroAD],[1 -poloAD])
sistCtrlAD = series(AD,sist);
sistCtrlAD = minreal(sistCtrlAD);

% Miramos como era el LGR despues de añadir el controlador de ADELANTO
% Situacion inicial
rlocus(sistCtrlAD);
hold on
limites = axis;
x = [limites(1):0.1:limites(2)];
y = tan(pi-tita)*x;
plot(x,y,'g-');
title('LGR de la planta despues de añadirle el controlador de ADELANTO');
pause
[kad,pad] = rlocfind(sistCtrlAD) 
close

% Cálculo de ctes (kp,kv) para el sistema con el controlador de adelanto
sistKCtrlAD = series(tf([kad],[1]),sistCtrlAD);
sistKCtrlAD = minreal(sistKCtrlAD);
switch tipo
    case 0
        kpad=dcgain(sistKCtrlAD);
        essad = 1/(1+kpad);
    case 1
        sistKsCtrlAD = series(tf([1 0],[1]),sistKCtrlAD);
        sistKsCtrlAD = minreal(sistKsCtrlAD);
        kvad = dcgain(sistKsCtrlAD);
        essad = 1/kvad;
end

% En base a las mejoras por las ctes -> Comentar lo de debajo
% %Mejora total a conseguir
% factor = ess/error;
% % Mejora debida al controlador AD
% mejoraAD = ess/essad;
% % Lo que queda por mejorar
% mejoraADRE = factor/mejoraAD;
% A partir de la mejora
% poloRE = ceroRE/mejoraADRE
% RE = tf([1 -ceroRE],[1 -poloRE]);
% sistCtrlADRE = series(RE,sistCtrlAD)

switch tipo
    case 0
        kpadre = (1-error)/error
        poloRE = ceroRE*kpad/kpadre
    case 1
        kvadre = 1/error
        poloRE = ceroRE*kvad/kvadre
end

display('Controlador de RETARDO');
RE = tf([1 -ceroRE],[1 -poloRE])
sistCtrlADRE = series(RE,sistCtrlAD);
ADRE = series(AD,RE);


% Calcular el valor de K
rlocus(sistCtrlADRE);
hold on
limites = axis;
x = [limites(1):0.1:limites(2)];
y = tan(pi-tita)*x;
plot(x,y,'g-');
title('LGR de la planta despues de añadirle el controlador de ADELANTO-RETARDO');
pause
[K,P] = rlocfind(sistCtrlADRE) 
close

sistkADRE = series(tf([K],[1]),sistCtrlADRE);
kADRE = series(tf([K],[1]),ADRE);
%% Error en estado estable

lazo_abierto = sistkADRE;
error_escalon = error_est_estable(lazo_abierto,'escalon');
error_rampa = error_est_estable(lazo_abierto,'rampa');

%% Respuesta en lazo cerrado a un escalón y una rampa
lazo_cerrado = feedback(lazo_abierto,1,-1);
dibujar_respuestas(lazo_cerrado);

%% Impresión de resultados

    disp ('=================================================');
    disp ('      CARACTERÍSTICAS CONTROLADOR TIPO AR:       ');
    disp ('=================================================');
    disp ('            ');
    disp ('Función de trasferencia del controlador ');
    disp ('----------------------------------------');
    kADRE
    disp ('            ');
    disp ('Parámetros: ');
    disp ('------------');
    disp (['  Tp  = ' num2str(tpico,4) 's']);
    disp (['  Ts  = ' num2str(tasent,4) 's']);
    disp (['  OS  = ' num2str(os,4) '%']);
    disp ('            ');
    disp ('Errores:    ');
    disp ('------------');
    disp (['  Escalón  : ess = ' num2str(error_escalon,4)]);
    disp (['  Rampa : ess  = ' num2str(error_rampa,4)]);
    disp ('    ');