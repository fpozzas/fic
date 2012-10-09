close all;
% Apartado 3: Señales complejas
% Secuencia 
nn = 0:25; 
xx = exp(j*nn / 3); 
% Representación 
subplot(411);
stem(nn,real(xx));
title('Parte real');
xlabel('Indice (n)'); 
subplot(412);
stem(nn,imag(xx));
title('Parte imaginaria');
xlabel('Indice (n)');
subplot(413);
stem(nn,abs(xx));
title('Módulo');
xlabel('Indice (n)');
subplot(414);
stem(nn,angle(xx));
title('Fase (en el intervalo -pi:+pi)');
xlabel('Indice (n)');
