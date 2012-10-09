function [] = displaysys(sys)
% Respuesta al escal�n
figure(1);
hold on;
%axis([0 7 0 2]);
step(sys);
grid;
title('Respuesta al escal�n');
% Respuesta a la rampa
figure(2);
step(series(sys,tf([0 1],[1 0])));
%axis([0 8 0 8]);
hold on;
ramp = [0:0.1:8];
plot(ramp,ramp,'g');
grid;
title('Respuesta a la rampa');
end

