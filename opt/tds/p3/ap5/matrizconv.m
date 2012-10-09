% Alumno: Daniel Fernández Núñez
% [ H ] = matrizconv(hn,N)
function [ H ] = matrizconv(hn,N);

n = (0:N-1)';
k = 0:N-1;
h_n0 = n * ones(1,N);
h_k = ones(N,1) * k;
h = h_n0 - h_k;
H =hn(mod(h,N)+1);


end

