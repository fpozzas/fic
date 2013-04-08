function [] = discretizar(sist,ctrl,metodo)

T = input('Introduzca el período de muestreo: ');
disp('  ');

switch metodo
    case 1
        met ='zoh' ;
    case 2
        met ='tustin';
end

lazo_abierto = series(ctrl,sist);
disp('Función de transferencia en lazo abierto discreta');
lazo_abiertod = c2d(lazo_abierto,T,met)
disp(' ')
disp('Funcion de transferencia en lazo cerrado discreto');
lazo_cerradod = feedback(lazo_abiertod,1,-1)
disp(' ')

% Respuesta para un escalón
figure(1);
hold on
title('Salida para un escalón del sistema continuo y discreto');
step(lazo_cerradod,0:T:10);
lazo_abiertoc = series(ctrl,sist);
lazo_cerradoc = feedback(lazo_abiertoc,1,-1);

% Respuesta para una rampa
mod_rampa = tf([1],[1 0]);
lazo_c_rampa = series(mod_rampa,lazo_cerradoc);
lazo_c_rampad = c2d(lazo_c_rampa,T,met);
figure(2);
hold on 
title('Salida para una rampa del sistema continuo y discreto');
step(lazo_c_rampad,0:T:10);

end

