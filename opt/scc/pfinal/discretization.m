function [] = discretization(Gs,Gc)
disp('Seleccionar m�todo de discretizaci�n:');
disp('1) Adaptaci�n a la respuesta al escal�n');
disp('2) Transformaci�n bilinear de Tustin');
flag = input('Selecci�n: ');
T = input('Introducir T: ');
switch flag
    case 1
        method = 'zoh';
    case 2
        method = 'tustin';
end;
% Funciones de transferencia discretas
G = series(Gc,Gs);
dG = c2d(G,T,method);
H = feedback(G,1);
dH = c2d(H,T,method);

% Dibujado de las respuestas sobre las gr�ficas de los controladores
% Escal�n
figure(1);
hold on;
title('Respuesta al escal�n (continua y discreta)');
step(dH,0:T:7);
% Rampa
figure(2);
hold on;
title('Respuesta a la rampa (continua y discreta');
drampH = c2d(series(tf([0 1],[1 0]),H),T,method);
step(drampH,0:T:8);
% Resultados
disp('%%%%%%%%%%%%%%%');
disp('Discretizaci�n');
disp('%%%%%%%%%%%%%%%');
disp('Funci�n de transferencia discreta en lazo abierto');
dG
disp('Funci�n de transferencia discreta en lazo cerrado');
dH
end


