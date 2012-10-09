% Control PID
% EJEMPLO DEL NISE
%numGs = [0 0 1 8];
%denGs = poly([-3 -6 -10])
%Introducir %OS: 20
%Introducir Tp: 0.198
%Introducir Ess: 0.492
%Introducir cero del PI: -0.5
function [Gc] = PIDcontroller(Gs)
disp('Construir control PID desde:');
disp('1) %OS y Tp');
disp('2) %OS y Ts ');
disp('3) Tp y Ts ');
flag = 0;
while(flag~=1 && flag~=2 && flag~=3)
    flag = input('Selección: ');
end;
switch flag
    case 1
        pos = input('Introducir %OS: ');
        Tp = input('Introducir Tp: ');
    case 2
        pos = input('Introducir %OS: ');
        Ts = input('Introducir Ts: ');
    case 3
        Tp = input('Introducir Tp: ');
        Ts = input('Introducir Ts: ');
end;

zeroPI = input('Introducir cero de la parte PI: ');

% Cálcular Gc
% Calculamos los parametros alfa, Wd, Wn y ratio para
% todos los casos de entrada
switch flag
    case 1 % pos & Tp
        ratio = -log(pos/100)/sqrt(pi^2+[log(pos/100)]^2);
        Wd = pi/Tp;
        Wn = Wd/(sqrt(1-ratio^2));
        alfa = ratio*Wn;
    case 2 % pos & Ts
        ratio = -log(pos/100)/sqrt(pi^2+[log(pos/100)]^2);
        alfa = 4/Ts;
        Wn = alfa/ratio;
        Wd = Wn*sqrt(1-ratio^2);
    case 3 % Tp & Ts
        Wd = pi/Tp;
        alfa = 4/Ts;
        ratio = alfa/sqrt(Wd^2 + alfa^2);
        Wn = alfa/ratio;
end;
pole = -alfa+Wd*1i;

numGs = cell2mat(Gs.num);
denGs = cell2mat(Gs.den);
% Cáculo del cero de PD mediante suma de los ángulos
sum_theta = angle(polyval(numGs,pole)/polyval(denGs,pole));
phi = pi-sum_theta;
zeroPD = -(Wd/tan(phi)+alfa)

GcPD = tf([1 -zeroPD],1);
GcPI = tf([1 -zeroPI],[1 0]);
GcPID = GcPI*GcPD;
GPID = series(GcPID,Gs);

% Cálculo de la constante K y Gc
rlocus(GPID);
hold on;
ejes = axis;
x1 = -alfa;
y1 = ejes(3):0.1:ejes(4);
x2 = ejes(1):0.1:ejes(2);
y2 = Wd;
plot(x1,y1);
plot(x2,y2);
disp('Hacer zoom en el LGR y enter para continuar');
pause;
[K,poles] = rlocfind(GPID);
close;
Gc = series(tf(K,1),GcPID);
% Cálculo de parámetros
% OJO: son los de la respuesta transitoria (correspondiente a PD),
% tal como pide en el enunciado.
switch flag
    case 1 % pos & Tp
        Ts = 4/alfa;
    case 2 % pos & Ts
        Tp = pi/Wd;
    case 3 % Tp & Ts
        pos = exp(-pi*ratio/sqrt(1-ratio^2))*100;
end;

% Lazo abierto
G = series(Gc,Gs);
% Cálculo de errores
ess_step = ess(G,'step');
ess_ramp = ess(G,'ramp');
% Lazo cerrado
H = feedback(G,1);
% Gráficos
displaysys(H);
% Resultados
disp('%%%%%%%%%%%%%%%')
disp('Controlador PID')
disp('%%%%%%%%%%%%%%%')
disp('Gc(s) = ');
Gc
disp('Parametros de la respuesta transitoria:');
disp(['%OS = ' num2str(pos) '%']);
disp(['Tp = ' num2str(Tp) 's']);
disp(['Ts = ' num2str(Ts) 's']);
disp(['Ess(escalón) = ' num2str(ess_step)]);
disp(['Ess(rampa) = ' num2str(ess_ramp)]);
disp('%%%%%%%%%%%%%');        
end
        
        
        
        
        
        
        
        
        
        
        
        
        
        