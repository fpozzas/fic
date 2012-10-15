% Practica 2 (PAM y ASK)

close all;
clear all;
%%%%%%% Parámetros %%%%%%%%%%%

% Tipo de modulacion
tipo='ASK';
% Numero de niveles de modulacion
M=4;
% Periodo de simbolo
N=10;
% Simbolos a transmitir
K=10000;
% Numero de periodos de simbolos a mostrar
P=10;
% Relacion energia / ruido
EbNo = 10;
% Frecuencia
w0 = pi/N;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parametros derivados
k = 0:K-1;
bps = ceil(log2(M));
% PAM params
ponder = 2.^(bps-1:-1:0);
Ai = 2*(1:M)-1-M;

%% Generar senal a enviar 

bits = rand(1,K*bps)>0.5;
% Modulacion
mbits = vec2mat(bits,bps);
symb = Ai((ponder*mbits')+1); % Simbolos en M-PAM
% s(n)
delta = zeros(N,1);
delta(1) = 1;
sn = delta*symb;
sn = sn(:)';
% p(n)
pulso = ones(1,N);
% ASK
if (strcmp('ASK',tipo))
    pulso = cos(w0*(1:N)) .* pulso;
end
Ep = sum(pulso.^2);
% u(n)
un = conv(sn,pulso);
un = un(1:N*K);

%%%%%%% Generacion de la senal recibida
%% Ruido
% Calculamos Es -> Eb -> No
% Es (caso M-PAM y ASK)
Es = Ep*(M*M-1)/3;
% Eb (Caso M-PAM y ASK)
Eb = Es/log2(M);
% Calculamos No (caso general)
No = Eb/(10^(EbNo/10));
nn = randn(1,N*K)*sqrt(No/2)+1j*randn(1,N*K)*sqrt(No/2);
rn = un + nn;


%% Filtro adaptado
mf = [ zeros(1,N) fliplr(pulso)/Ep];
zn = conv(rn,mf);
zn = zn(2*N:end);


%% Muestreo de la salida del filtro
matrix_zn = reshape(real(zn),N,K);
samples = delta'*matrix_zn;



%% Decisor PAM/ASK
v = bsxfun(@minus,Ai,samples(:));
[i,j] = min(abs(v),[],2);
symb_prima = Ai(j);

%% Calculo de errores
errores = sum((symb-symb_prima)~=0);
media_errores = errores/K;

% Funcion Q(x) equivalente a:
% Q(x) = erfc(x/sqrt(2))/2
if (strcmp('ASK',tipo))
    prob_error_symb = (2*(M-1)/M) * erfc((sqrt(2*Ep/No))/sqrt(2))/2;
    prob_error_bit = prob_error_symb/log2(M);
else
    prob_error_symb = (2*(M-1)/M) * erfc((sqrt(2*Ep/No))/sqrt(2))/2;
    prob_error_bit = prob_error_symb/log2(M);
end

%% Figuras
figure(1);
hold on;
plot(un(1:N*P));
stem(sn(1:N*P),'r');
title('Senales u(n) (azul) y s(n) (rojo)');

figure(2);
hold on;
plot(symb*sqrt(Ep),0,'*')
title('Constelación de la señal a transmitir (normalizada)');

figure(3);
hold on;
stem(sn(1:N*P),'b');
plot(real(rn(1:N*P)),'r');
title('Señal recibida r(n) y señal s(n)');

figure(4);
hold on;
stem(sn(1:N*P));
plot(real(zn(1:N*P)),'r');
title('Salida del filtro adaptado');

figure(5);
hold on;
plot(real(samples)*sqrt(Ep),0,'*')
title('Constelación de la señal a recibida (normalizada)');

figure(6);
hold on;
sn_prima_dec = delta*samples;
sn_prima_dec = sn_prima_dec(:);
stem(sn_prima_dec(1:N*P));
title('Senal s''(n)');

%% Resultados
disp(['Modulación ' tipo ':']);
disp(['- M =' num2str(M)]);
disp(['- N =' num2str(N)]);
disp(['- K =' num2str(N)]);
disp(['- P =' num2str(N)]);
disp(['- EbNo =' num2str(EbNo)]);
if (strcmp('ASK',tipo))
    disp(['- w0 =' num2str(w0)]);
end
disp('Resultados: ');
disp(['No. de errores   = ' num2str(errores)]);
disp(['Media de errores = ' num2str(media_errores)]);
disp(['Ps teórica       = ' num2str(prob_error_symb)]);
disp(['Pb teórica       = ' num2str(prob_error_bit)]);

