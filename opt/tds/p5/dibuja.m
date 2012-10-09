% Alumno: Daniel Fernández Núñez
% [] = dibuja(B,A)
function [] = dibuja(B,A)

N = 512;
Fs = 8000;

figure;
% Plano Z
subplot(121);
zplane(B,A);
% Respuesta en frecuencia
subplot(122);
[H,F] = freqz(B,A,N,'whole',Fs);
plot(F,abs(H));
xlabel('Hz');

end
