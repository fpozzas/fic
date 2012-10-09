close all;
% Apartado 4: Señales discretas obtenidas
% mediante el muestreo de señales continuas
fs = 8000;
% EJERCICIO 1
% Se toman muestras para 10ms
% t=n*Ts; n= t/Ts = t*fs = 10ms*8KHz= 80 muestras 
Lms = 0:0.125:10;
f0 = 300;
n = 80;
L = 0:n;
figure(1);
hold on;
subplot(2,1,1);
senv = sin(2*pi*f0/fs*L);
stem(Lms,senv);
title('Stem de sinusoide de F0 = 300Hz');
xlabel('ms');
subplot(2,1,2);
plot(Lms,senv);
title('Plot de sinusoide de F0 = 300Hz');
xlabel('ms');

% EJERCICIO 2
s1 = sin(2*pi*100/fs*L);
s2 = sin(2*pi*225/fs*L);
s3 = sin(2*pi*350/fs*L);
s4 = sin(2*pi*475/fs*L);
figure(2);
hold on;
subplot(4,1,1);
stem(Lms,s1);
title('Stem de sinusoide de F0 = 100Hz');
xlabel('ms');
subplot(4,1,2);
stem(Lms,s2);
title('Stem de sinusoide de F0 = 225Hz');
xlabel('ms');
subplot(4,1,3);
stem(Lms,s3);
title('Stem de sinusoide de F0 = 350Hz');
xlabel('ms');
subplot(4,1,4);
stem(Lms,s4);
title('Stem de sinusoide de F0 = 475Hz');
xlabel('ms');
% Con:
% sound(sX,8000);
% se puede comprobar que conforme vamos aumentado la frecuencia
% de 100 a 475, el sonido se hace más agudo.

% EJERCICIO 3
s1 = sin(2*pi*7525/fs*L);
s2 = sin(2*pi*7650/fs*L);
s3 = sin(2*pi*7775/fs*L);
s4 = sin(2*pi*7900/fs*L);
figure(3);
hold on;
subplot(4,1,1);
stem(Lms,s1);
title('Stem de sinusoide de F0 = 7525Hz');
xlabel('ms');
subplot(4,1,2);
stem(Lms,s2);
title('Stem de sinusoide de F0 = 7650Hz');
xlabel('ms');
subplot(4,1,3);
stem(Lms,s3);
title('Stem de sinusoide de F0 = 7775Hz');
xlabel('ms');
subplot(4,1,4);
stem(Lms,s4);
title('Stem de sinusoide de F0 = 7900Hz');
xlabel('ms');
% Vemos como estas frecuencias se parecen a las del ejercicio 2.
% El motivo de esto es que no se cumple que fs>=2*f0, por lo que
% lo que estamos viendo en las gráficas son el "alias" de la señal,
% que despues de sufrir un desplazamiento en frecuencia parece que
% solapa a la señal original.