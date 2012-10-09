function y=genexp(c,n0,L) 
% GENEXP genera una señal exponencial: c ^ n 
% uso: y = genexp(c,n0,L) 
% c: entrada escalar que da la razón entre términos 
% n0: instante de comienzo (entero) 
% L: longitud de la señal generada 
% y: señal de salida Y(1:L)
if (L <= 0) 
    error('GENEXP: longitud no positiva') 
end 
nn = n0 + [0:L-1].'; % vector de índices 
y = c .^ nn;

end

