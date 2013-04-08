%% Pr�ctica final de SCC :
%% Dise�o y control digital 

%Limpieza
clc;
clear all;
close all;

%% Peticion de datos de la planta
disp('-----------------------------------------------');
disp(' DISE�O Y REALIZACI�N DIGITAL DE CONTROLADORES ');
disp('-----------------------------------------------');
disp('                                               ');
disp('                                               ');
disp('           <Nombre del Alumno>                ');
disp('                                               ');
disp('-----------------------------------------------');

numgp = input('Vector de coeficientes del numerador de la f.t. de la planta: ')
dengp = input('Vector de coeficientes del denominador de la f.t. de la planta: ')


disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
disp(' FUNCI�N DE TRANSFERENCIA DE LA PLANTA ');
disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
sist = tf(numgp,dengp)

%% Peticion de tipo de controlador a realizar
disp('                                             ');
disp('Tipos de controlador que se pueden construir:');
disp('1 : Controlador P');
disp('2 : Controlador PID');
disp('3 : Controlador adelanto-retardo');
disp('                                             ');
tipoContr = input('Introduzca alguno de estos controladores: ');
disp('                                             ');

while( tipoContr~=1 && tipoContr~=2 && tipoContr~=3)
    tipoContr = input('Introduzca 1,2 � 3: ');
    disp('            ');
end

switch tipoContr
    case 1
        ctrl = controladorP(sist);
    case 2
        ctrl = controladorPID(sist);
    case 3    
        ctrl = controladorAR(sist);
end;

%% Discretizaci�n del sistema construido
disp('                        ');
disp('Tipos de discretizaci�n:');
disp('1 : M�todo zoh          ');
disp('2 : Metodo de Tustin    ');
disp('                        ');
metodo = input('Introduzca alguno de estos m�todos: ');
disp('                       ');

while( metodo~=1 && metodo~=2)
    tipoContr = input('Introduzca 1 � 2: ');
    disp('            ');
end
discretizar(sist,ctrl,metodo);
