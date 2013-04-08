%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Entrenamiento %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear all;
close all;
lena = double(imread('lena.png'))/255;
lena_bordes = double(imread('lena_bordes.png'))/255;
%imagen1 = double(imread('pasillo.png'))/255;
%imagen2 = double(imread('pasillo_bordes.png'))/255;

[nfil,ncol]=size(lena);
ventana = 7;
central = ceil(ventana/2);
T = [];
P = [];


% Se seleccionan aleatoriamente las ventanas para el entrenamiento,
% distinguiendo entre las que son borde y las que son fondo

% Selección de "bordes" (realmente solo son candidatos a serlo, que tengan tonos altos)

nbordes = 0;
while (nbordes<7000)
	x = ceil(mod(rand*100000,nfil-ventana+1));
	y = ceil(mod(rand*100000,ncol-ventana+1));
	if lena(x+central-1,y+central-1)>=0.4
		nbordes = nbordes + 1;
		P(:,nbordes) = reshape(lena(x:x + ventana-1,y:y + ventana-1),49,1);
		T(nbordes) = lena_bordes(x+central-1,y+central-1);
	end
end

% Selección de fondos (seleccionar muchos más bordes que fondos da mejor resultado, estos tienen tonos bajos)
nfondos = 0;
while (nfondos<400)
	x = ceil(mod(rand*100000,nfil-ventana));
	y = ceil(mod(rand*100000,ncol-ventana));
	if lena(x+central-1,y+central-1)<0.4
		nfondos = nfondos + 1;
		P(:,nfondos) = reshape(lena(x:x + ventana-1,y:y + ventana-1),49,1);
		T(nfondos) = lena_bordes(x+central-1,y+central-1);
	end
end

% Entrenamiento

net = newff(minmax(P),[70 20 1],{'logsig' 'logsig' 'logsig'}, 'trainrp');
net.trainParam.epochs=5000;
red.trainParam.show=100;
net.trainParam.min_grad=1e-12;
net.trainParam.goal=0.0001;

net = train(net,P,T);

save red_p2.mat net;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Simulación %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;

load red_p2.mat;
%imagen = double(imread('lena.png'))/255;
imagen = double(imread('pasillo.png'))/255;

[nfil,ncol]=size(imagen);
ventana = 7;
central = ceil(ventana/2);
P = [];
S = [];

img = zeros(size(imagen)+ventana-1);
img(central:nfil+central-1,central:ncol+central-1) = imagen; 
for x=central:nfil+central-1
	for y=central:ncol+central-1
		P(:,y-central+1) = reshape(img(x-central+1:x+central-1,y-central+1:y+central-1),49,1);
	end
	S(x-central+1,:)=sim(net,P);
end

S = uint8(255*S);

imwrite(S,'salida_p2.png');
 
