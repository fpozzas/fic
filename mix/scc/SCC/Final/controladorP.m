%% Práctica final de SCC :
%% Controlador P 
function [controlador] = controladorP(sist)

%% Información del tipo de controlador
disp('--------------------');
disp(' CONTROLADOR TIPO P ');
disp('--------------------');
disp('                    ');

%% Petición de parámetros
disp('Parámetros :               ');
disp('1 : Porcentaje de sobrepaso');
disp('2 : Tiempo de pico         ');
disp('3 : Tiempo de asentamiento ');
disp('                           ');
parametro = input('Introduzca qué parámetro va a fijar: ');
disp('                           ');

while(parametro~=1 && parametro~=2 && parametro~=3)
   parametro = input('Introduzca 1,2 ó 3: ');
   disp('             ');
end

switch parametro
    case 1
        os = input('Introduzca un valor para el porcentaje de sobrepaso(0-100%): ');
    case 2
        tpico = input('Introduzca un valor para el tiempo de pico: ');
    case 3
        tasent = input('Introduzca un valor para el tiempo de asentamiento: ');
end


%% Cálculo de la constante K
rlocus(sist);
hold on;
limites = axis;
x = [limites(1):0.1:limites(2)];
switch parametro
    case 1
        tita = atan(-pi/log(os/100));
        pendiente = tan(pi-tita);
        y = pendiente*x;
    case 2
        wd = pi/tpico;
        y = wd*ones(1,length(x));
    case 3
        alfa = 4/tasent;
        x = -alfa; 
        y = [limites(3):0.1:limites(4)];
end;
% Creo que este hold on sobra
hold on;
plot(x,y,'g-');
pause;
[k,polos] = rlocfind(sist)
close

%% Cálculo del resto de parámetros
disp('¡NO COGER RAÍCES EN EL EJE REAL!')
npolo = input(['Introduzca el polo dominante (1-' num2str(length(polos)) '): ']);
disp(' ');
switch parametro
    case 1 %% Se conoce os
        tpico = pi/abs(imag(polos(npolo)));
        tasent = 4/abs(real(polos(npolo)));
    case 2 %% Se conoce tpico
        tan_tita = abs(imag(polos(npolo)))/abs(real(polos(npolo)));
        os=exp(-pi/tan_tita)*100;
        tasent = 4/abs(real(polos(npolo)));
    case 3 %% Se conoce tasent;
        tan_tita = abs(imag(polos(npolo)))/abs(real(polos(npolo)));
        os=(exp(-pi/tan_tita))*100;
        tpico = pi/abs(imag(polos(npolo)));
end

%% Error en estado estable
controlador = tf([k],[1]);
lazo_abierto = series(controlador,sist);
error_escalon = error_est_estable(lazo_abierto,'escalon');
error_rampa = error_est_estable(lazo_abierto,'rampa');

%% Respuesta en lazo cerrado a un escalón y una rampa
lazo_cerrado = feedback(lazo_abierto,1,-1);
dibujar_respuestas(lazo_cerrado);

%% Impresion de resultados

    disp ('=================================================');
    disp ('      CARACTERÍSTICAS CONTROLADOR TIPO P:        ');
    disp ('=================================================');
    disp ('             ');
    disp ('Función de transferencia (K) :');
    disp ('-------------');
    disp (['  K   = ' num2str(k,4)]);    
    disp ('             ');
    disp ('Parámetros : ');
    disp ('-------------');
    disp (['  Tp  = ' num2str(tpico,4) 's']);
    disp (['  Ts  = ' num2str(tasent,4) 's']);
    disp (['  OS  = ' num2str(os,4) '%']);
    disp ('            ');
    disp ('Errores :    ');
    disp ('-------------');
    disp (['  Escalón  : ess = ' num2str(error_escalon,4)]);
    disp (['  Rampa : ess  = ' num2str(error_rampa,4)]);
    disp ('    ');
         