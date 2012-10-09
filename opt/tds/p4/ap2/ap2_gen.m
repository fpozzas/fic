% Alumno: Daniel Fernández Núñez
% Apartado 2 Generacion de imagenes

N = 64;
M = 20;
[f1,f2,f3,f4,f5,f6,f7] = imgeom(N,M);
f1 = uint8(f1); imwrite(f1,'lbh.tif');
f2 = uint8(f2); imwrite(f2,'lbv.tif');
f3 = uint8(f3); imwrite(f3,'rect1.tif');
f4 = uint8(f4); imwrite(f4,'rect2.tif');
f5 = uint8(f5); imwrite(f5,'rect3.tif');
f6 = uint8(f6); imwrite(f6,'rect4.tif');
f7 = uint8(f7); imwrite(f7,'circulo.tif');