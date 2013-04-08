x = [];
y = [];
for i = 191:240
	for j = 191:240
		x(end+1) = i;
		y(end+1) = j;
	end 
end

xs = [];
ys = [];
for i = 1:length(x)
	xs(i,:) = x(i)-3:x(i)+3;
	ys(i,:) = y(i)-3:y(i)+3;
end

DizP = [];
DizT = [];
cont=0;
for n = 1:length(x)
		for i = 1:7
			for j = 1:7
				DizP(i+7*(j-1),n) = lena(xs(n,i),ys(n,j));
			end
		end
		DizT(n) = lena_bordes(x(n),y(n))/255;
end

NET = newff(minmax(DizP), [100,60,1]);
net = train(NET,P,T);


x = [];
y = [];
for i = 191:240
	for j = 191:240
		x(end+1) = i;
		y(end+1) = j;
	end 
end

xs = [];
ys = [];
for i = 1:length(x)
	xs(i,:) = x(i)-3:x(i)+3;
	ys(i,:) = y(i)-3:y(i)+3;
end




DizP = [];
DizT = [];
cont=0;
for n = 1:length(x)
		cont = cont+1;
		for i = 1:7
			for j = 1:7
				DizP(i+7*(j-1),cont) = lena(xs(n,i),ys(n,j));
			end
		end
end

salida = sim(net,DizP);

for n = 1:length(salida)
	if salida(n)<0
		salida(n) = 0;
	else
	end
end

salida = salida.*255;
salida = round(salida);

Dibujo = [];
for i = 1:50
	for j = 1:50
		Dibujo(i,j) = salida(j+50*(i-1));
	end
end
