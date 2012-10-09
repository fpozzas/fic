% Practica 2 (QAM)

close all;
clear all;
%%%%%%% Parámetros %%%%%%%%%%%

% Numero de niveles de modulacion
M=16;
% Periodo de simbolo
N=10;
% Simbolos a transmitir
K=100000;
% Numero de periodos de simbolos a mostrar
P=10;
% Relacion energia / ruido
EbNo = 15;
% Frecuencia
w0 = pi/N;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parametros derivados
k = 0:K-1;
bps = ceil(log2(M));
% QAM params
ponder = 2.^(bps-1:-1:0);
Aij= 2*(1:sqrt(M))-1-sqrt(M);
mapping = constlay(log2(M))+1;

%% Generar senal a enviar 
% p(n)
pulso = ones(1,N);
Ep = sum(pulso.^2);
% Modulacion
bits = rand(1,K*bps)>0.5;
mbits = vec2mat(bits,bps);
amplitudes = (ponder*mbits')+1;
[i,j] = arrayfun(@(x)(find(mapping==x)),amplitudes);
symb1 = (2*i(1:K)-1-sqrt(M));
symb2 = (2*j(1:K)-1-sqrt(M));
symb = symb1 - symb2;
% s(n)
delta = zeros(N,1);
delta(1) = 1;
sn1 = delta*symb1;
sn2 = delta*symb2;
sn1 = sn1(:)';
sn2 = sn2(:)';
% u(n)
un1 = conv(sn1,pulso.*cos(w0*(1:N)));
un1 = un1(1:N*K);
un2 = conv(sn2,pulso.*sin(w0*(1:N)));
un2 = un2(1:N*K);
un = un1-un2;

%%%%%%% Generacion de la senal recibida
%% Ruido
% Calculamos Es -> Eb -> No
% Es (caso QAM)
Es = Ep*(M-1)/3;
% Eb (Caso QAM)
Eb = Es/log2(M);
% Calculamos No (caso general)
No = Eb/(10^(EbNo/10));
nn = randn(1,N*K)*sqrt(No/2)+1j*randn(1,N*K)*sqrt(No/2);
rn = un + nn;

%% Filtros adaptados
mf1 = [ zeros(1,N) fliplr(pulso.*cos(w0*(1:N))/(Ep/2))];
mf2 = [ zeros(1,N) fliplr(pulso.*-sin(w0*(1:N))/(Ep/2))];
zn1 = conv(rn,mf1);
zn1 = zn1(2*N:end);
zn2 = conv(rn,mf2);
zn2 = zn2(2*N:end);

%% Muestreo de las salidas de los filtros
matrix_zn1 = reshape(real(zn1),N,K);
samples1 = delta'*matrix_zn1;
matrix_zn2 = reshape(real(zn2),N,K);
samples2 = delta'*matrix_zn2;

%% Decisor PAM/ASK

v = bsxfun(@minus,Aij,samples1(:));
[x,i] = min(abs(v),[],2);
symb1_prima = Aij(i);

v = bsxfun(@minus,Aij,samples2(:));
[x,j] = min(abs(v),[],2);
symb2_prima = Aij(j);

symb_prima = symb1_prima-symb2_prima;

%% Calculo de errores
errores = sum((symb-symb_prima)~=0);
media_errores = errores/K;

% Funcion Q(x) equivalente a:
% Q(x) = erfc(x/sqrt(2))/2

prob_error_symb = (4*(sqrt(M)-1)/sqrt(M)*erfc(sqrt(Ep/No)/sqrt(2))/2)*...
    (1-(sqrt(M)-1)/sqrt(M)*erfc(sqrt(Ep/No)/sqrt(2))/2);
prob_error_bit = prob_error_symb/log2(M);

%% Figuras
figure(1);
hold on;
plot(un(1:N*P));
title('Senal transmitida u(n)');

figure(2);
hold on;
plot(symb1*sqrt(Ep/2),symb2*sqrt(Ep/2),'*')
title('Constelación de la señal a transmitir (normalizada)');

figure(3);
hold on;
plot(real(rn(1:N*P)),'b');
title('Señal recibida r(n)');

figure(4);
hold on;
plot(real(zn1(1:N*P)),'b');
plot(real(zn2(1:N*P)),'r');
title('Salidas de los filtros adaptados');

figure(5);
hold on;
plot(real(samples1)*sqrt(Ep/2),real(samples2)*sqrt(Ep/2),'*')
title('Constelación de la señal a transmitir (normalizada)');

%% Resultados
disp(['Modulación QAM:']);
disp(['- M =' num2str(M)]);
disp(['- N =' num2str(N)]);
disp(['- K =' num2str(N)]);
disp(['- P =' num2str(N)]);
disp(['- EbNo =' num2str(EbNo)]);
disp(['- w0 =' num2str(w0)]);
disp('Resultados: ');
disp(['No. de errores   = ' num2str(errores)]);
disp(['Media de errores = ' num2str(media_errores)]);
disp(['Ps teórica       = ' num2str(prob_error_symb)]);
disp(['Pb teórica       = ' num2str(prob_error_bit)]);