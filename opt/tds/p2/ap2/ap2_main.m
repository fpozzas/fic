% Alumno: Daniel Fernández Núñez
% APARTADO 2
disp('Apartado 2: Transformadas de Fourier de secuencias discretas');
disp('Seleccionar la secuencia:');
disp('1) x1(n)');
disp('2) x2(n)');
secuencia = input('Seleccion: ');
N = input('Introducir N: ');
M = input('Introducir M: ');
switch secuencia
    case 1
        L = 2*M+1;
        xn = ones(L,1);
        figure(1);
        title('Señal discreta x1')
        stem(0:L-1,xn);
        tf_analisis_x1(N,M);
        
    case 2
        L = 4*M+1;
        xn1 = 1:2*M+1;
        xn2 = 2*M:-1:1;
        xn = [xn1 xn2]';
        figure(1);
        title('Señal discreta x2')
        stem(0:L-1,xn);
        tf_analisis_x2(N,M);
end;
% DFT BUCLES
tinicio=clock;
X=dft_bucles(xn,L,N);
t1=etime(clock,tinicio);
figure(2);
subplot(2,4,2);
plot(0:2*pi/N:2*pi*(N-1)/N,abs(X));
axis([0 2*pi ylim]);
title('DFT Bucles: Modulo');
xlabel('Indice (n)'); 
subplot(2,4,6);
plot(0:2*pi/N:2*pi*(N-1)/N,imag(X));
axis([0 2*pi ylim]);
title('DFT Bucles: Fase');
xlabel('Indice (n)');

% DFT Vectores
tinicio=clock;
[X,F]=dft_vectores(xn,L,N);
t2=etime(clock,tinicio);
%F
figure(2);
subplot(2,4,3);
plot(0:2*pi/N:2*pi*(N-1)/N,abs(X));
axis([0 2*pi ylim]);
title('DFT Vectores: Modulo');
xlabel('Indice (n)'); 
subplot(2,4,7);
plot(0:2*pi/N:2*pi*(N-1)/N,imag(X));
axis([0 2*pi ylim]);
title('DFT Vectores: Fase');
xlabel('Indice (n)');

% FFT
tinicio=clock;
X=fft(xn,N);
t3=etime(clock,tinicio);
figure(2);
subplot(2,4,4);
plot(0:2*pi/N:2*pi*(N-1)/N,abs(X));
axis([0 2*pi ylim]);
title('FFT: Modulo');
xlabel('Indice (n)'); 
subplot(2,4,8);
plot(0:2*pi/N:2*pi*(N-1)/N,imag(X));
axis([0 2*pi ylim]);
title('FFT: Fase');
xlabel('Indice (n)');

% Tiempos
disp(['Tiempo DFT Bucles   = ',num2str(t1)]);
disp(['Tiempo DFT Vectores = ',num2str(t2)]);
disp(['Tiempo FFT          = ',num2str(t3)]);
