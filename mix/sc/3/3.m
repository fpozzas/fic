imagen = double(imread('images3_07.bmp'))/255;

P = [];
for i=0:16:255
	for j=0:16:255
		for k=0:16:255
			P(:,end+1) = [i;j;k];
		end
	end
end
			
			
			
			
[nfil,ncol,ndim] = size(imagen);
n = 0;
Ptrain = [];
while (n<10000)
	x = ceil(mod(rand*100000,nfil));
	y = ceil(mod(rand*100000,ncol));
	n = n + 1;
	Ptrain(:,n) = imagen(x,y,:);
end

NET = newsom([0 1; 0 1; 0 1], [6 6], 'randtop');
net = train(NET, Ptrain);

save red_p3.mat

%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Simulación %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%

load red_p3.mat
imagen = double(imread('images3_07.bmp'))/255;

Pimg = [];
for i = 1:nfil
  i
  for j = 1:ncol
    Pimg(end+1,:) = imagen(i,j,:);
  end
end

save Pimg_3.mat Pimg

Y = sim(net,Pimg);
NUM = length(Y(1,:));


maxInt = [];

for i = 1:NUM
  m = max(Y(:,i));
  for j = 1:36
    if (Y(j,i) == m)
      maxInt(i) = j;
    end
  end
end


salida = [];
for i = 1:NUM
  salida(ceil(i/ncol),mod(i,ncol)+1,:) = net.IW{1,1}(maxInt(i),:);
end

salida = uint8(round(255*salida));

