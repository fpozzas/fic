% Alumno: Daniel Fernández Núñez
% refleja(L,N)
function [ ] = refleja(L,N)

% Rampa
xn = xn_rampa(L);
if (N>L)
    xn2 = [xn ; zeros(N-L,1)];
else
    xn2 = xn;
end;
% Reflexion circular
xr = xn2(mod(-1*(0:N-1)',N)+1);
% TFs
X = dft(xn,L,N);
Xr = dft(xr,N,N);
% Dibujos
figure;
hold on;

subplot(231);
stem(0:L-1,xn);
title('x(n)');
subplot(234);
stem(0:length(xr)-1,xr);
title('xr(n)');
subplot(232);
plot(0:2*pi/N:2*pi*(N-1)/N,abs(X));
title('Modulo de X(n)');
axis([0 2*pi ylim]);
subplot(235);
plot(0:2*pi/N:2*pi*(N-1)/N,abs(Xr));
title('Modulo de Xr(n)');
axis([0 2*pi ylim]);
subplot(233);
plot(0:2*pi/N:2*pi*(N-1)/N,imag(X));
title('Fase de X(n)');
axis([0 2*pi ylim]);
subplot(236);
plot(0:2*pi/N:2*pi*(N-1)/N,imag(Xr));
title('Fase de Xr(n)');
axis([0 2*pi ylim]);



end

