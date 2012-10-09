% Apartado 1
% Ejemplo de stem
nn = 0:30;
sinus = sin(nn/2 +1);

figure(1);
hold on;
subplot(2,1,1);
stem(sinus);
axis([0 31 -1 1]);
subplot(2,1,2);
stem(nn,sinus);
axis([0 31 -1 1])

% La diferencia es que stem(sinus) toma el indice de la matriz sinus
% como el valor del eje x (ej: sinus[3] -> (3,sinus[3])) por lo que es
% como si pusiesemos stem(1:31,sinus) y entonces la señal sale desplazada
% una unidad a la derecha si la comparamos con stem(nn,sinus)