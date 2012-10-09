function [ ] = desplaza(L,n0,N)
% desplaza(L,n0,N)

xn = xn_rampa(L);
xn = [xn ; zeros(N-L,1)];

% Desplazamiento mediante el modulo
xn_index = 0:N-1;
xn_d1_index = mod(xn_index - n0,N);
xn_d1 = xn(xn_d1_index+1);

% Desplazamiento mediante DFT e IDFT

X = dft(xn,N,N);
k = 0:length(X)-1;
X_d2 = X.*(exp(-1j*(2*pi/N)*k'*n0));
xn_d2 = idft(X_d2);

% Dibujos

figure;
hold on;
subplot(311)
stem(0:N-1,xn);
title('xn original');
subplot(312);
stem(0:N-1,xn_d1);
title('xn desplazada (mediante modulo)');
subplot(313);
stem(0:N-1,round(real(xn_d2)));
title('xn desplazada (mediante transformadas)');
end
