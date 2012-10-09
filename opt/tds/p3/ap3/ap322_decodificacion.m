% Alumno: Daniel Fernández Núñez
% Apartado 3.2.2 Señales de audio (decodificacion)

close all;

% PARA F0=FS/2

% Vista.wav
f0 = FS/2;

audio = 'vista.wav';
[xn,FS,NBITS] = wavread(audio);
[Xn,xd,Xd,fs] = codifica2(audio,f0);
wavwrite(xd,fs,NBITS,'vista_codificada.wav');

% Decodificacion de vista_codificada.wav
audio = 'vista_codificada.wav';
[xd,FS,NBITS] = wavread(audio);
[Xd,xprima,Xprima,fs] = codifica2(audio,f0);

figure;
hold on;
subplot(411);
plot(xn);
title('x(n) original');
subplot(412);
plot(xd);
title('x(n) decodificada');
subplot(413);
N=8192;
plot(0:fs/N:fs*(N-1)/N,Xn);
title('X(w) original');
axis([0 fs ylim]);
subplot(414);
plot(0:fs/N:fs*(N-1)/N,Xprima);
title('X(w) decodificada');
axis([0 fs ylim]);

sound(xn,fs);
sound(xprima,fs);

% PARA F0=2000Hz

% Vista.wav
f0 = 2000;

audio = 'vista.wav';
[xn,FS,NBITS] = wavread(audio);
[Xn,xd,Xd,fs] = codifica2(audio,f0);
wavwrite(xd,fs,NBITS,'vista_codificada.wav');

% Decodificacion de vista_codificada.wav
audio = 'vista_codificada.wav';
[xd,FS,NBITS] = wavread(audio);
[Xd,xprima,Xprima,fs] = codifica2(audio,f0);

figure;
hold on;
subplot(411);
plot(xn);
title('x(n) original');
subplot(412);
plot(xd);
title('x(n) decodificada');
subplot(413);
N=8192;
plot(0:fs/N:fs*(N-1)/N,Xn);
title('X(w) original');
axis([0 fs ylim]);
subplot(414);
plot(0:fs/N:fs*(N-1)/N,Xprima);
title('X(w) decodificada');
axis([0 fs ylim]);

sound(xn,fs);
sound(xprima,fs);

% Codificada.wav
audio = 'codificada.wav';
[xd,FS,NBITS] = wavread(audio);

f0 = FS/2;
[xprima,fs] = codifica(audio,f0);

sound(xd,fs);
sound(xprima,fs);
