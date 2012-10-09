% Alumno: Daniel Fernández Núñez
% convol(L1,L2,N);
function [ ] = convol(L1,L2,N)

x1 = xn_pulso(L1);
x2 = xn_pulso(L2);
% Convolucion lineal
xlin = conv(x1,x2);
% Convolucion circular
X1 = dft(x1,L1,N);
X2 = dft(x2,L2,N);
Xcir = X1.*X2;
xcir = idft(Xcir);
% Dibujos
figure;
hold on;

subplot(411);
stem(x1);
title('x1');
subplot(412);
stem(x2);
title('x2');
subplot(413);
stem(0:L1+L2-2,xlin);
title('Convolucion lineal');
subplot(414);
stem(0:N-1,round(real(xcir)));
title('Convolucion circular');
end

