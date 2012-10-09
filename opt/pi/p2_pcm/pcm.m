%%%%%%%%%%%
%% PCM %%%%
%%%%%%%%%%%
close all;
%%%%%%%%%%%%%%%
% Parametros  %
%%%%%%%%%%%%%%%

nplot = 1:8; % Muestras a dibujar
L1 = 4; % Niveles del cuantificador
L2 = 8;
L3 = 32;
fs = 8000; % Frecuencia de muestreo
f = 2500; % Frecuencia de la señal sinusoidal

% 
%% Generacion de seÃ±ales
%%%%%%%%%%%%%%%%%%%%%%%

% Senoidales

dur=10;
n=0:(1/fs):dur;
yd=cos(2*pi*f*n);

% SeÃ±ales FM

fc=440;
fm=440;
Ac=6;
Im=1.5;
dur=3; % 1 segundo de duracion
t=0:1/fs:dur;
xd=Ac.*cos(2*pi*t*fc + Im.*cos(2*fm*t));

% SeÃ±al de audio

[zd,fs_zd,n] = wavread('vista.wav');

% Señal de prueba del enunciado
%S = [-1.4 -1.2 -1.15 -0.1 0.21 0.36 0.97 1.04 1.56 1.71];
%S = [-2.4 4.4 9.2 9.15 5.1 9.21 4.36 7.97 8.04 5.56 9.71];
%S = [1.4 1.2 1.15 0.1 0.21 0.36 0.97 1.04 1.56 4 5]
%S = yd;
%S = xd;
S = zd'; fs = fs_zd;

%
%% Cuantificador uniforme
%%%%%%%%%%%%%%%%%%%%%%%%
figure(1);
% Original
subplot(411);
plot(nplot,S(nplot));
title('Señal de entrada');
% L1
subplot(412);
[mse1,Q1,Qmin1] = cunif(L1,S);
stem(nplot,Q1(nplot));
title('L1');
% L2
subplot(413);
[mse2,Q2,Qmin2] = cunif(L2,S);
stem(nplot,Q2(nplot));
title('L2');
% L3
subplot(414);
[mse3,Q3,Qmin3] = cunif(L3,S);
stem(nplot,Q3(nplot));
title('L3');
% Imprime MSEs
disp(['L1: ' num2str(L1) ' niveles -> mse = ' num2str(mse1) ]);
disp(['L2: ' num2str(L2) ' niveles -> mse = ' num2str(mse2) ]);
disp(['L3: ' num2str(L3) ' niveles -> mse = ' num2str(mse3) ]);

%
%% Codificacion
%%%%%%%%%%%%%%%

C1 = codigo(L1);
C2 = codigo(L2);
C3 = codigo(L3);

CQ1 = C1(Qmin1,:)';
CQ1 = CQ1(:);

CQ2 = C2(Qmin2,:)';
CQ2 = CQ2(:);

CQ3 = C3(Qmin3,:)';
CQ3 = CQ3(:);

%
%% Resultados varios
%%%%%%%%%%%%%%%%%%%%%%%%
disp(['Frecuencia de muestreo: ' num2str(fs) ' muestras/sg']);
disp(['Velocidad de C1: ' num2str(fs*length(C1(1,:))) ' bits/sg']); 
disp(['Velocidad de C2: ' num2str(fs*length(C2(1,:))) ' bits/sg']); 
disp(['Velocidad de C3: ' num2str(fs*length(C3(1,:))) ' bits/sg']); 
disp(['Tamaño de C1: ' num2str(length(CQ1)) ' bits (' num2str(length(CQ1)/8) ' bytes)']);
disp(['Tamaño de C2: ' num2str(length(CQ2)) ' bits (' num2str(length(CQ2)/8) ' bytes)']);
disp(['Tamaño de C3: ' num2str(length(CQ3)) ' bits (' num2str(length(CQ3)/8) ' bytes)']);
% Para escuchar las señales:
%sound(S,fs);
%sound(Q1,fs);
%sound(Q2,fs);
%sound(Q3,fs);



