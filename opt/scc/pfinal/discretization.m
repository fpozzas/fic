function [] = discretization(Gs,Gc)
disp('Seleccionar método de discretización:');
disp('1) Adaptación a la respuesta al escalón');
disp('2) Transformación bilinear de Tustin');
flag = input('Selección: ');
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

% Dibujado de las respuestas sobre las gráficas de los controladores
% Escalón
figure(1);
hold on;
title('Respuesta al escalón (continua y discreta)');
step(dH,0:T:7);
% Rampa
figure(2);
hold on;
title('Respuesta a la rampa (continua y discreta');
drampH = c2d(series(tf([0 1],[1 0]),H),T,method);
step(drampH,0:T:8);
% Resultados
disp('%%%%%%%%%%%%%%%');
disp('Discretización');
disp('%%%%%%%%%%%%%%%');
disp('Función de transferencia discreta en lazo abierto');
dG
disp('Función de transferencia discreta en lazo cerrado');
dH
end


