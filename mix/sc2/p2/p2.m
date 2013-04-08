%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Entrenamiento %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear all;
close all;
lena = double(imread('lena.png'))/255;
lena_bordes = double(imread('lena_bordes.png'))/255;

[nfil,ncol]=size(lena);
ventana = 7;
central = ceil(ventana/2);
T = [];
P = [];


%%%%%% Selección de ventanas

% Selección de bordes
n = 0;
while (n<8000)
	x = ceil(mod(rand*100000,nfil-ventana+1));
	y = ceil(mod(rand*100000,ncol-ventana+1));
	if lena_bordes(x+central-1,y+central-1)>=0.5
		n = n + 1;
		P(:,end+1) = reshape(lena(x:x + ventana-1,y:y + ventana-1),49,1);
		T(end+1) = lena_bordes(x+central-1,y+central-1);
	end
end

% Selección de fondos cercanos a bordes
n = 0;
while (n<3000)
	x = ceil(mod(rand*100000,nfil-ventana+1));
	y = ceil(mod(rand*100000,ncol-ventana+1));
	if lena_bordes(x,y)<0.3
		if lena_bordes(x+central-1,y+central-1)>0.5
			n = n + 1;
			P(:,end+1) = reshape(lena(x:x + ventana-1,y:y + ventana-1),49,1);
			T(end+1) = lena_bordes(x+central-1,y+central-1);
		end
	end
end

% Selección de fondos aleatorios
n = 0;
while (n<3000)
	x = ceil(mod(rand*100000,nfil-ventana+1));
	y = ceil(mod(rand*100000,ncol-ventana+1));
	if lena_bordes(x+central-1,y+central-1)<0.3
		n = n + 1;
		P(:,end+1) = reshape(lena(x:x + ventana-1,y:y + ventana-1),49,1);
		T(end+1) = lena_bordes(x+central-1,y+central-1);
	end
end

% Entrenamiento

net = newff(minmax(P),[120 50 1],{'logsig' 'logsig' 'purelin'}, 'trainrp');
net.trainParam.epochs=5000;
net.trainParam.min_grad=1e-12;
net.trainParam.goal=0.0001;

[net,TR,Y,E] = train(net,P,T);

save red_p2.mat;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Simulación %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;

load red_p2.mat;
%imagen = double(imread('lena.png'))/255;
imagen = double(imread('graf1.png'))/255;

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
 
 
 
 % MSE
 bordes = imread('bordes.png');
 mse(bordes,S);

 
