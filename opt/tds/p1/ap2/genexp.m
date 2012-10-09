function y=genexp(c,n0,L) 
% GENEXP genera una se�al exponencial: c ^ n 
% uso: y = genexp(c,n0,L) 
% c: entrada escalar que da la raz�n entre t�rminos 
% n0: instante de comienzo (entero) 
% L: longitud de la se�al generada 
% y: se�al de salida Y(1:L)
if (L <= 0) 
    error('GENEXP: longitud no positiva') 
end 
nn = n0 + [0:L-1].'; % vector de �ndices 
y = c .^ nn;

end

