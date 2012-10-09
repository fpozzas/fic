% Alumno: Daniel Fernández Núñez
% [ Xn,xd,Xd,fs ] = codifica2(wav,f0)
function [ Xn,xd,Xd,fs ] = codifica2(wav,f0);
N = 8192;
% Obtenemos la informacion del audio
[xn,fs,nbits] = wavread(wav);
L = length(xn);
% Desplazamiento
k0 = N*f0/fs;
n = (0:L-1)';
dn = cos((2*pi/N)*k0*n);
xd = xn.*dn;

Xn = abs(fft(xn,N));
Xd = abs(fft(xd,N));

end

