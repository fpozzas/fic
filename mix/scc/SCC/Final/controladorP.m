%% Pr�ctica final de SCC :
%% Controlador P 
function [controlador] = controladorP(sist)

%% Informaci�n del tipo de controlador
disp('--------------------');
disp(' CONTROLADOR TIPO P ');
disp('--------------------');
disp('                    ');

%% Petici�n de par�metros
disp('Par�metros :               ');
disp('1 : Porcentaje de sobrepaso');
disp('2 : Tiempo de pico         ');
disp('3 : Tiempo de asentamiento ');
disp('                           ');
parametro = input('Introduzca qu� par�metro va a fijar: ');
disp('                           ');

while(parametro~=1 && parametro~=2 && parametro~=3)
   parametro = input('Introduzca 1,2 � 3: ');
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


%% C�lculo de la constante K
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

%% C�lculo del resto de par�metros
disp('�NO COGER RA�CES EN EL EJE REAL!')
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

%% Respuesta en lazo cerrado a un escal�n y una rampa
lazo_cerrado = feedback(lazo_abierto,1,-1);
dibujar_respuestas(lazo_cerrado);

%% Impresion de resultados

    disp ('=================================================');
    disp ('      CARACTER�STICAS CONTROLADOR TIPO P:        ');
    disp ('=================================================');
    disp ('             ');
    disp ('Funci�n de transferencia (K) :');
    disp ('-------------');
    disp (['  K   = ' num2str(k,4)]);    
    disp ('             ');
    disp ('Par�metros : ');
    disp ('-------------');
    disp (['  Tp  = ' num2str(tpico,4) 's']);
    disp (['  Ts  = ' num2str(tasent,4) 's']);
    disp (['  OS  = ' num2str(os,4) '%']);
    disp ('            ');
    disp ('Errores :    ');
    disp ('-------------');
    disp (['  Escal�n  : ess = ' num2str(error_escalon,4)]);
    disp (['  Rampa : ess  = ' num2str(error_rampa,4)]);
    disp ('    ');
         