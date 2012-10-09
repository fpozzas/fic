%
%% Práctica
%%%%%%%%%%%%%%

% Matriz zigzag para matrices 8x8
zigzag = [ 1     2     6     7    15    16    28    29;
      3     5     8    14    17    27    30    43; 
      4     9    13    18    26    31    42    44;
     10    12    19    25    32    41    45    54;
     11    20    24    33    40    46    53    55;
     21    23    34    39    47    52    56    61;
     22    35    38    48    51    57    60    62;
     36    37    49    50    58    59    63    64];

nbloque = 8;

% Coeficientes retenidos (max: 64)
coef = 1;

% Selección zonal
S = zigzag<=coef;

% Carga de imagen
X = double(imread('lenna512.tif'));
%X = double(imread('airfield512.tif'));

figure(1);
image(X);
colormap(gray(256));
title('Original');

ncols=length(X(1,:));
nfilas=length(X(:,1));

% DCT e IDCT
Cp = zeros(ncols);
Xp = Cp;
for i=1:nbloque:nfilas
    for j=1:nbloque:nfilas
        x = i:i+nbloque-1;
        y = j:j+nbloque-1;
        M = mydct(X(x,y));
        Cp(x,y)=S.*M;
        Xp(x,y)=myidct(Cp(x,y));
    end
end

figure(2);
image(Xp);
colormap(gray(256));
title('Recuperada');

% MSE
mse = mean(mean((X-Xp).^2))
        