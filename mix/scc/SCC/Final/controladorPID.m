%% Práctica final de SCC :
%% Controlador PID 
function [kPID] = controladorPID(sist)

%% Información del tipo de controlador
disp('------------------------');
disp('  CONTROLADOR TIPO PID  ');
disp('------------------------');
disp('                    ');

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

%Posicion del cero
display(' ');
ceroPI = input('Introduzca la posición del cero de la parte PI (<0): ');
display(' ');


%% Cálculo de la función de transferencia del controlador
% Diseño de la parte PD
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
p = -alfa+i*wd

%Calculamos la suma de las fases de todas las titas
[numgp, dengp] = tfdata(sist,'v');

suma_fases = angle(polyval(numgp,p)/polyval(dengp,p));

fi_cero= pi-suma_fases;

if(fi_cero>(pi/2))
    ceroPD = abs(real(p) - imag(p)/tan(fi_cero))
else
    ceroPD = abs(real(p) + imag(p)/tan(pi-fi_cero))
end


PD = tf([1 ceroPD],1);
PI = tf([1 -ceroPI],[1 0]);
PID = PD*PI;

GPID = series(PID,sist);

% Calcular el valor de K - Diseño de la parte PI
rlocus(GPID);
hold on;
limites = axis;
x1 = -alfa;
y1 = [limites(3):0.1:limites(4)];
y2 = wd;
x2 = [limites(1):0.1:limites(2)];
plot(x1,y1,'g-');
plot(x2,y2,'g-');
pause;
[k,polos] = rlocfind(GPID)
close

kPID = series(tf([k],[1]),PID);

%% Cálculo de los parámetros restantes
switch par
    case 1 % Porcentaje de sobrepaso - Tiempo de pico
        tasent = 4/alfa;
    case 2 % Porcentaje de sobrepaso - Tiempo de asentamiento
        tpico = pi/wd;
    case 3 % Tiempo de pico - Tiempo de asentamiento
        wn = sqrt(wd*wd + alfa*alfa);
        r = alfa/wn;
        os = exp(-pi*r/sqrt(1-r*r))*100;
end
 
%% Error en estado estable
lazo_abierto = series(tf([k],[1]),GPID);
error_escalon = error_est_estable(lazo_abierto,'escalon');
error_rampa = error_est_estable(lazo_abierto,'rampa');

%% Respuesta en lazo cerrado a un escalón y una rampa
lazo_cerrado = feedback(lazo_abierto,1,-1);
dibujar_respuestas(lazo_cerrado);

%% Impresión de resultados

    disp ('=================================================');
    disp ('      CARACTERÍSTICAS CONTROLADOR TIPO PID:      ');
    disp ('=================================================');
    disp ('            ');
    disp ('Función de trasferencia del controlador ');
    disp ('----------------------------------------');
    kPID
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