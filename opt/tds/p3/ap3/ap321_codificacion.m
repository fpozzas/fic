% Alumno: Daniel Fernández Núñez
% Apartado 3.2.1 Señales de audio (codificacion)

close all;
% Tono.wav
audio = 'tono.wav';
[Y,FS,NBITS] = wavread(audio);

f0 = 2000;
[xd,fs] = codifica(audio,f0);
sound(Y,fs);
sound(xd,fs);

f0 = FS/2;
[xd,fs] = codifica(audio,f0);
sound(xd,fs);

% Vista.wav
audio = 'vista.wav';
[Y,FS,NBITS] = wavread(audio);

f0 = 2000;
[xd,fs] = codifica(audio,f0);
sound(Y,fs);
sound(xd,fs);

f0 = FS/2;
[xd,fs] = codifica(audio,f0);
sound(xd,fs);

