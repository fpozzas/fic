% Main.m %
close all;
clear all;
disp('PRACTICA SISTEMAS DE CONTROL POR COMPUTADOR');
% Planta Gp %
disp('Introducir planta:');
numGs = input('Vector de coeficientes de numerador: ');
%numGs = [0 0 1];
%numGs = [0 0 1 8];
denGs = input('Vector de coeficientes de denominador: ');
%denGs = poly([-1 -2 -10]);
%denGs = poly([-3 -6 -10]);
%denGs = poly([0 -6 -10]);
Gs = tf(numGs,denGs);
Gs
%PIDcontroller(Gs);
disp('Seleccionar controlador:');
disp('1) Controlador P');
disp('2) Controlador PID');
disp('3) Controlador Lag-Lead');
seleccion = input('Selección: ');
switch seleccion
    case 1
        Gc = Pcontroller(Gs);
    case 2
        Gc = PIDcontroller(Gs);
    case 3
        Gc = LLcontroller(numGs,denGs);
end;
discretization(Gs,Gc);

