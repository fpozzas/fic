close all;
% 2.1 Ejercicios (TF)
N=0:200;
x0 = cos(pi*N);
x1 = sin(pi*N);
x2 = cos(pi/4*N);
% Señales
figure(1);
subplot(311);
stem(N,x0);
subplot(312);
stem(N,x1);
subplot(313);
stem(N,x2);
% Transformadas
figure(2);
subplot(311);
[X,W]=dtft(x0,256);
XdB=20*log10(abs(X));
plot(W,XdB);
subplot(312);
[X,W]=dtft(x1,256);
XdB=20*log10(abs(X));
plot(W,XdB);
subplot(313);
[X,W]=dtft(x2,256);
XdB=20*log10(abs(X));
plot(W,XdB);
% Comentarios
% Las TF de los cosenos tienen sus dos picos en pi y pi/4 respectivamente
% mientras que el seno es más caótico.


