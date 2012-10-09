% Alumno: Daniel Fernández Núñez
% Apartado 5.1 Convoluciones mediante el producto de matrices

% Caso 1
L1 = 15;
L2 = 15;
N = 20;
x1 = [xn_pulso(L1) ; zeros(N-L1,1)]; 
x2 = [xn_pulso(L2) ; zeros(N-L2,1)]; 
H = matrizconv(x2,N);
xcir = H*x1;

figure;
hold on;

subplot(311);
stem(x1);
title('x1 (L1=L2=15,N=20)');
subplot(312);
stem(x2);
title('x2 (L1=L2=15,N=20)');
subplot(313);
stem(0:N-1,round(real(xcir)));
title('Convolucion circular (L1=L2=15,N=20)');

% Caso 2
L1 = 10;
L2 = 2;
N = 10;
x1 = [xn_pulso(L1) ; zeros(N-L1,1)]; 
x2 = [xn_pulso(L2) ; zeros(N-L2,1)]; 
H = matrizconv(x2,N);
xcir = H*x1;

figure;
hold on;

subplot(311);
stem(x1);
title('x1 (L1=10,L2=2,N=10)');
subplot(312);
stem(x2);
title('x2 (L1=10,L2=2,N=10)');
subplot(313);
stem(0:N-1,round(real(xcir)));
title('Convolucion circular (L1=10,L2=2,N=10)');

% Caso del N minimo (N=11)
L1 = 10;
L2 = 2;
N = 11;
x1 = [xn_pulso(L1) ; zeros(N-L1,1)]; 
x2 = [xn_pulso(L2) ; zeros(N-L2,1)]; 
H = matrizconv(x2,N);
xcir = H*x1;

figure;
hold on;

subplot(311);
stem(x1);
title('x1 (L1=10,L2=2,N=11)');
subplot(312);
stem(x2);
title('x2 (L1=10,L2=2,N=11)');
subplot(313);
stem(0:N-1,round(real(xcir)));
title('Convolucion circular (L1=10,L2=2,N=11)');