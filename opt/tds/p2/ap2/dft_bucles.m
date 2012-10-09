% Alumno: Daniel Fernández Núñez
function [ X ] = dft_bucles(xn,L,N)

for k = 0:N-1
    temp = 0;
    for n = 0:L-1
        temp = temp + xn(n+1)*exp(-1j*(2*pi/N)*k*n);
    end
    X(k+1)=temp;
end



