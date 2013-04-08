clear all;
close all;

%%%%%%%%%%%%%%%%%%%%
% DATOS DE ENTRADA %
%%%%%%%%%%%%%%%%%%%%

% Periodo de simbolo
N = 10;
% Dominio del periodo de simbolo para h(n) y p(n)
L = 10;
% Numero de simbolos a transmitir
K = 1000;
% El ancho de banda del canal (W < pi)
W = pi/2;
% Número de periodos de símbolo a visualizar en la pantalla
M = 10;
% Cociente Eb/No expresado en decibelios
EbNo = 6;
% Eb/No sin unidades
EbNoSU = 10^(EbNo/10);


% Pulso p(n)
%pulso = pulso_rectangular(L,N);
pulso = pulso_nyquist(L,N);
rangop = -L*N:L*N;

%%%%%%%%%%%%%%%
% Transmisión %
%%%%%%%%%%%%%%%

% Secuencia de bits a enviar
rangob = 0:K-1;
bits = randn(1,K);
bits(1:K) = bits(1:K)>=0;

% Variable Ik: 1 si el bit es 0, -1 si el bit es 1
Ik = bits*(-2) + 1;

% Creamos s(n)

rangod = 0:N*K-1;
deltas = mod(rangod,N)==0;
deltas = deltas * 1; % para pasar de una matriz de booleanos a otra de doubles
sn = deltas;
sn(1:N:N*K) = deltas(1:N:N*K) .* Ik(1:1:K);

% Creamos u(n)

un = conv(sn, pulso);

% Calculamos la energía de bit Eb
Eb = sum(abs(pulso).^2);


%%%%%%%%%
% Canal %
%%%%%%%%%

% Se escoge h(n) como la respuesta al impulso de un
% filtro paso bajo ideal

rangohn=-L*N:L*N;

hn = sin(W * rangohn);
hn(1:L*N) = hn(1:L*N) ./ (pi * rangohn(1:L*N));
hn(L*N + 1) = W/pi;
hn(L*N+2:end) = hn(L*N+2:end) ./ (pi * rangohn(L*N+2:end));

% Calculamos su TF

[HW, rangoHW] = dtft(hn, length(hn));
HW = abs(HW);
mx = max(HW);
HW = HW/mx;

%%%%%%%%%%%%%
% Recepción %
%%%%%%%%%%%%%



% Señal recibida r(n)
% La calculamos como r(n) = conv(u(n),h(n)) + v(n)
rn = conv(un,hn);
% donde v(n) es ruido blanco gaussiano
No = Eb/EbNoSU;
vn = randn(1,length(rn)) * sqrt(No/2);

% r(n) definitiva
rn = rn + vn;

% FILTRO RECEPTOR
% Usamos señalización antipodal tal que s1(n) = -s2(n)
% y p(n) = -p(n), por lo que el filtro óptimo es
% hopt = K' · p(-n), donde K' vale 1/Eb para normalizarlo
hopt = 1/Eb * pulso(end:-1:1);
rangohop = rangop;

% Salida del filtro adaptado
sfa = conv(rn,hopt);

%%%%%%%%%%%%
% Decisión %
%%%%%%%%%%%%

% Calculamos s'(n)
rangosfa = floor(length(hn)/2) + floor(length(hopt)/2) + L*N+1;
sprima = sfa(rangosfa:end-rangosfa+1) .* deltas;
% Decidimos: si la amplitud es mayor que 0 es un bit 0, si es menor es un bit 1
decision = sprima(1:N:end)<0;
decision = decision * 1;

%%%%%%%%%%%%%%
% Resultados %
%%%%%%%%%%%%%%


%%% Dibujos %%%
% M primeros símbolos del tren de deltas a trasmitir s(n)
figure;
stem(0:M*N-1, sn(1:M*N));
title('Secuencia de símbolos a transmitir');
grid;
axis([0,N*M,-2,2]);

% Pulso y su TF (normalizado)
[pulsotf, rangoptf] = dtft(pulso,length(pulso));
pulsotf = abs(pulsotf);
mx = max(pulsotf);
pulsotf = pulsotf/mx;

figure;
subplot(2,1,1)
plot(rangop, pulso)
title('p(n)');
grid;
subplot(2,1,2)
plot(rangoptf, pulsotf);
title('P(W)');
grid;


% Señal s(n) y u(n)

figure;
stem(0:M*N-1, sn(1:M*N));
hold on;
plot(0:M*N-1, un(L*N+1:L*N + M*N), 'red');
hold off;
title('Señal transmitida u(n) y señal s(n)');
grid;
axis([0,N*M,-2,2]);

% Señales H(w) y TF del pulso P(W)

figure;
plot(rangoHW,HW);
hold on;
plot(rangoptf, pulsotf, 'red');
hold off;
title('Respuesta en frecuencia del canal H(w) y TF del pulso P(W)');
grid;


% Señal s(n) y r(n)

figure;
stem(0:M*N-1, sn(1:M*N));
hold on;
dibrn = floor(length(hn)/2) + L*N+1;
plot(0:M*N-1, rn(dibrn:dibrn-1 + M*N), 'red');
hold off;
title('Señal recibida r(n) y señal s(n)');
grid;
axis([0,N*M,-2,2]);

% Salida del filtro adaptado

figure;
stem(0:M*N-1, sn(1:M*N));
hold on;
dibsfa = floor(length(hopt)/2) + dibrn;
plot(0:M*N-1, sfa(dibsfa:dibsfa-1 + M*N), 'red');
hold off;
title('Salida del filtro adaptado y señal s(n)');
grid;
axis([0,N*M,-2,2]);

% Diagrama de ojo
% D.OJO: PRINCIPIO:
figure;
i = dibsfa;
hold on;
while(i<(dibsfa+N*K-1)) 
    plot(0:2*N-1, sfa(i:i+2*N-1));
    i = i + 2*N;
end;
hold off;
title('Diagrama de ojo');
grid;
% D:OJO: FIN

% Secuencia de observaciones

figure;
stem(0:M*N-1, sprima(1:M*N));
title('Secuencia de M primeras observaciones de sprima(n)');
grid;
axis([0,N*M,-2,2]);

%%% Calculos %%%

% Número de bits erroneos
nbe = sum(not(bits(1:end) == decision(1:end)))
% Probabilidad de error estimada
pee = nbe / K
% Probabilidad de error del sistema
pes = (1/2) * erfc(sqrt(EbNoSU))