% Control Retardo-Adelanto
% EJEMPLO DEL NISE
%numGs = 1;
%denGs = poly([0 -6 -10]);
%Introducir %OS: 20
%Introducir Tp: 0.45
%Introducir Ess: 0.0313
%Introducir cero del retardo: -0.04713
%Introducir polo del adelanto: -29.1

function [ Gc ] = LLcontroller(numGs,denGs)

% Comprobación del tipo
poles = roots(denGs);
type = sum(poles==0);
disp(['Planta de tipo' type]);
if (type>1)
    disp('** Error LLcontroller: el tipo de la planta debe ser 0 o 1');
    return;
end;

disp('Construir control Lag-Lead desde:');
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

ess_input = input('Introducir Ess: ');
zero_lag = input('Introducir cero del retardo: ');
pole_lead = input('Introducir polo del adelanto: ');

% Cálcular Gc
% Calculamos los parametros alfa, Wd, Wn y ratio para
% todos los casos de entrada
% Calculamos también el parámetro restante en cada caso.
switch flag
    case 1 % pos & Tp
        ratio = -log(pos/100)/sqrt(pi^2+[log(pos/100)]^2);
        Wd = pi/Tp;
        Wn = Wd/(sqrt(1-ratio^2));
        alfa = ratio*Wn;
        Ts = 4/alfa;
    case 2 % pos & Ts
        ratio = -log(pos/100)/sqrt(pi^2+[log(pos/100)]^2);
        alfa = 4/Ts;
        Wn = alfa/ratio;
        Wd = Wn*sqrt(1-ratio^2);
        Tp = pi/Wd;
    case 3 % Tp & Ts
        Wd = pi/Tp;
        alfa = 4/Ts;
        ratio = alfa/sqrt(Wd^2 + alfa^2);
        Wn = alfa/ratio;
        pos = exp(-pi*ratio/sqrt(1-ratio^2))*100;
end;
pole = -alfa+Wd*1i;
% Parte compensada por adelanto
% Cálculo del cero a partir del polo dominante y
% la suma de angulos.
Gs = tf(numGs,denGs);
Gc_pole_lead = tf(1,[1 -pole_lead]);
G_lead = series(Gc_pole_lead,Gs);
numG_lead = cell2mat(G_lead.num);
denG_lead = cell2mat(G_lead.den);

sum_theta = angle(polyval(numG_lead,pole)/polyval(denG_lead,pole));
phi = pi-sum_theta;
zero_lead = -(Wd/tan(phi)+alfa);

Gc_lead = tf([1 -zero_lead],[1 -pole_lead]);

% Para calcular el polo de la parte compensada por retardo
% tendremos que calcular primero el factor de mejora deseado.
% polo_lag = cero_lag/fact_lag (1)
% El fact_lag es el factor de mejora que queda por mejorar después
% de aplicar la parte lead
% fact_lag = fact_mejora_total/fact_lead (2)
% donde:
% fact_mejora_total = Ess_sistema/Ess_deseado
% fact_lead = Ess_sistema/Ess_lead
% Sustituyendo y simplificando en (2):
% fact_lag = Ess_lead/Ess_deseado
% Sustituyendo y simplificando en (1):
% polo_lag = cero_lag*Ess_deseado/Ess_lead

% Para calcular las Ess debemos hallar primero las ganancias
% correspondientes a partir del sistema con el controlador de adelanto
% con su K correspondiente, que conseguiremos mediante rlocfind
G_lead = series(Gc_lead,Gs);
rlocus(G_lead);
hold on;
sgrid(ratio,0);
disp('Hacer zoom en el LGR y enter para continuar');
pause;
[K_lead,poles_lead] = rlocfind(G_lead);
close;
KG_lead = series(tf(K_lead,1),G_lead);
% Calculamos Ess_lead. Dependiendo del tipo de la planta
% usaremos la ganancia Kv o Kp.
switch type
    case 0
        ess_lead = ess(KG_lead,'step');
    case 1
        ess_lead = ess(KG_lead,'ramp');
end;
% Calculamos el polo de la parte lag
pole_lag = zero_lag*ess_input/ess_lead;
Gc_lag = tf([1 -zero_lag],[1 -pole_lag]);
% Calculamos la K para el controlador laglead
G_ll = series(Gc_lag,G_lead);
rlocus(G_ll);
hold on;
sgrid(ratio,0);
disp('Hacer zoom en el LGR y enter para continuar');
pause;
[K_ll,poles_ll] = rlocfind(G_ll);
close;
% Controlador final compensado
Gc = series(tf(K_ll,1),series(Gc_lag,Gc_lead));
% Función de transferencia en lazo abierto
G = series(tf(K_ll,1),G_ll);
% Errores en estado estable
ess_step = ess(G,'step');
ess_ramp = ess(G,'ramp');
% Función de transferencia en lazo cerrado
H = feedback(G,1);
% Gráficos
displaysys(H);
% Resultados
disp('%%%%%%%%%%%%%%%%%%%%')
disp('Controlador Lag-Lead')
disp('%%%%%%%%%%%%%%%%%%%%')
disp('Gc_lead(s) = ');
Gc_lead
disp('Gc_lag(s) = ');
Gc_lag
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
        



