% 2. Transformada de Fourier
nh=0:4;
h=ones(1,5)/5;
subplot(211);
stem(nh,h);
title('h(n)');
subplot(212);
[H,W]=dtft(h,500);
HdB=20*log10(abs(H));
plot(W,HdB);
axis([-4 4 -50 0]);
title('Modulo de la respueste en frecuencia del filtro');
