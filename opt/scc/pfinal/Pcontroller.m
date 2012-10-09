% Control P %
% EJEMPLO APUNTES
% numGs = [0 0 1];
% denGs = poly([-1 -2 -10]);
% %OS = 57.4
% Tp = 0.80933
function [Gc] = Pcontroller(Gs)
disp('Construir control P desde:');
disp('1) %OS');
disp('2) Tp ');
disp('3) Ts ');
flag = 0;
while(flag~=1 && flag~=2 && flag~=3)
    flag = input('Selección: ');
end;
switch flag
    case 1
        pos = input('Introducir %OS: ');
    case 2
        Tp = input('Introducir Tp: ');
    case 3
        Ts = input('Introducir Ts: ');
end;
rlocus(Gs);
hold on;
ejes = axis;
lenX = ejes(1):0.1:ejes(2);
lenY = ejes(3):0.1:ejes(4);
switch flag
    case 1
        ratio = -log(pos/100)/sqrt(pi^2+[log(pos/100)]^2);
        sgrid(ratio,0);
    case 2
        Wd = pi/Tp;
        plot(lenX,Wd*ones(1,length(lenX)),'b');
    case 3
        alfa = 4/Ts;
        plot(-alfa*ones(1,length(lenY)),lenY,'b');
end;
disp('Hacer zoom en el LGR y despues enter para continuar');
pause;
[K,poles] = rlocfind(Gs);
close;

disp('Elegir polo:');
for i=1:1:length(poles)
    disp([num2str(i) ')  ' num2str(poles(i))]);
end;
np = input('Selección: ');
% Cálculo de parámetros
alfap = abs(real(poles(np)));
Wdp = abs(imag(poles(np)));
% ratio = cos(theta) = alfa/hip = alfa/sqrt(Wd^2 + alfa^2) 
ratiop = alfap/sqrt(Wdp^2 + alfap^2);
pos = exp((-pi*ratiop)/sqrt(1-ratiop^2))*100;
Ts = 4/alfap;
Tp = pi/Wdp;
% Lazo abierto
Gc = tf([K],[1]);
G = series(Gc,Gs);
% Cálculo de errores
ess_step = ess(G,'step');
ess_ramp = ess(G,'ramp');
% Lazo cerrado
H = feedback(G,1);
% Gráficos
displaysys(H);
% Resultados
disp('%%%%%%%%%%%%%')
disp('Controlador P')
disp('%%%%%%%%%%%%%')
disp(['Gc(s) = K = ' num2str(K)]);
disp(['%OS = ' num2str(pos) '%']);
disp(['Tp = ' num2str(Tp) 's']);
disp(['Ts = ' num2str(Ts) 's']);
disp(['Ess(escalón) = ' num2str(ess_step)]);
disp(['Ess(rampa) = ' num2str(ess_ramp)]);
disp('%%%%%%%%%%%%%');        
end