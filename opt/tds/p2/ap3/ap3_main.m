% Alumno: Daniel Fernández Núñez
% 3. Analisis frecuencial de señales

% Ejercicio 1
f0 = 2000;
fs = 8000;
M = 10;
N = 1000;
L = 2*M+1;
n = 0:L-1;
xn = sin(2*pi*(f0/fs)*n);

figure(1);
hold on;
subplot(3,1,1);
stem(0:L-1,xn);
title('Secuencia x(n)');

XN=fft(xn,N);

subplot(3,1,2);
plot(0:fs/N:fs*(N-1)/N,abs(XN));
title('TF de x(n) (amplitud):');
axis([0 fs ylim]);

subplot(3,1,3);
plot(0:fs/N:fs*(N-1)/N,imag(XN));
title('TF de x(n) (imag):');
axis([0 fs ylim]);

% Ejercicio 2
N = 1024;

M = 50;
L = 2*M+1;
n = 0:L-1;

figure(2);
subplot(4,1,1);
plot(0:fs/N:fs*(N-1)/N,abs(fft(sin(2*pi*(100/fs)*n),N)));
title('TF de x(n) con f0=100 Hz');
axis([0 fs ylim]);

subplot(4,1,2);
plot(0:fs/N:fs*(N-1)/N,abs(fft(sin(2*pi*(225/fs)*n),N)));
title('TF de x(n) con f0=225 Hz');
axis([0 fs ylim]);

subplot(4,1,3);
plot(0:fs/N:fs*(N-1)/N,abs(fft(sin(2*pi*(350/fs)*n),N)));
title('TF de x(n) con f0=350 Hz');
axis([0 fs ylim]);

subplot(4,1,4);
plot(0:fs/N:fs*(N-1)/N,abs(fft(sin(2*pi*(475/fs)*n),N)));
title('TF de x(n) con f0=475 Hz');
axis([0 fs ylim]);

% Ejercicio 3
N = 1024;

M = 50;
L = 2*M+1;
n = 0:L-1;

figure(3);
subplot(4,1,1);
plot(0:fs/N:fs*(N-1)/N,abs(fft(sin(2*pi*(7525/fs)*n),N)));
title('TF de x(n) con f0=7525 Hz');
axis([0 fs ylim]);

subplot(4,1,2);
plot(0:fs/N:fs*(N-1)/N,abs(fft(sin(2*pi*(7650/fs)*n),N)));
title('TF de x(n) con f0=7650 Hz');
axis([0 fs ylim]);

subplot(4,1,3);
plot(0:fs/N:fs*(N-1)/N,abs(fft(sin(2*pi*(7775/fs)*n),N)));
title('TF de x(n) con f0=7775 Hz');
axis([0 fs ylim]);

subplot(4,1,4);
plot(0:fs/N:fs*(N-1)/N,abs(fft(sin(2*pi*(7900/fs)*n),N)));
title('TF de x(n) con f0=7900 Hz');
axis([0 fs ylim]);

% Ejercicio 4
% Lo mismo que ej2 solo
% que se usa ffshift para
% pasar de [0,2*pi) [-pi,pi)
N = 1024;

M = 50;
L = 2*M+1;
n = 0:L-1;

figure(3);
subplot(4,1,1);
plot(-fs/2:fs/N:fs/2*(N-1)/N,abs(fftshift(fft(sin(2*pi*(100/fs)*n),N))));
title('TF de x(n) con f0=100 Hz');
axis([-fs/2 fs/2 ylim]);

subplot(4,1,2);
plot(-fs/2:fs/N:fs/2*(N-1)/N,abs(fftshift(fft(sin(2*pi*(225/fs)*n),N))));
title('TF de x(n) con f0=225 Hz');
axis([-fs/2 fs/2 ylim]);

subplot(4,1,3);
plot(-fs/2:fs/N:fs/2*(N-1)/N,abs(fftshift(fft(sin(2*pi*(350/fs)*n),N))));
title('TF de x(n) con f0=350 Hz');
axis([-fs/2 fs/2 ylim]);

subplot(4,1,4);
plot(-fs/2:fs/N:fs/2*(N-1)/N,abs(fftshift(fft(sin(2*pi*(475/fs)*n),N))));
title('TF de x(n) con f0=475 Hz');
axis([-fs/2 fs/2 ylim]);
