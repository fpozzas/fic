function [] = dibujar_respuestas(sist_lazo_cerrado)
figure(1);
step(sist_lazo_cerrado);
axis([0 10 0 4]);
title('Salida para un escalón');
grid;
% Dividir el sist en lazo cerrado por s
figure(2);
step(series(sist_lazo_cerrado,tf([0 1],[1 0])));
axis([0 10 0 10]);
title('Salida para una rampa');
grid;
