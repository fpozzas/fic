% Alumno: Daniel Fernández Núñez
% G = pbajo(F,L,'mmovil1')
% G = pbajo(F,L,'mmovil2')
% G = pbajo(F,L,'mmovil3')
% G = pbajo(F,L,'mediana')
% G = pbajo(F,L,'outrange',umbral)
% NOTA: Los filtros de media movil funcionan
% solamente para L=3
function [G] = pbajo(F,L,filtro,umbral)

F = double(F);
% Los filtros lineales de media movil
% funcionan solo para L=3
if (strcmp(filtro,'mmovil1'))
    H = ones(3)/9;
    G = conv2(F,H);
    G = G(2:end-1,2:end-1);
elseif (strcmp(filtro,'mmovil2'))
    H = ones(3);
    H(2,2) = 2;
    H = H/10;
    G = conv2(F,H);
    G = G(2:end-1,2:end-1);
elseif (strcmp(filtro,'mmovil3'))
    H = ones(3);
    H(2,:) = H(2,:)*2;
    H(:,2) = H(:,2)*2;
    H = H/16;
    G = conv2(F,H);
    G = G(2:end-1,2:end-1);
elseif (strcmp(filtro,'mediana'))
    G = ones(size(F));
    Fp = ones(length(F(1,:))+floor(L/2)*2,length(F(:,1))+floor(L/2)*2)*128;
    Fp(ceil(L/2):length(Fp(1,:))-floor(L/2),ceil(L/2):length(Fp(:,1))-floor(L/2))=F;
    for n=ceil(L/2):length(Fp(1,:))-floor(L/2)
        for m=ceil(L/2):length(Fp(:,1))-floor(L/2)
            f=Fp(n-floor(L/2):n+floor(L/2),m-floor(L/2):m+floor(L/2));
            g=sort(f(:));
            G(n-floor(L/2),m-floor(L/2)) = median(g);
        end
    end
elseif (strcmp(filtro,'outrange'))
    H = ones(L);
    Gp = conv2(F,H);
    Gp = 1/(L^2 -1) * (Gp(ceil(L/2):end-(floor(L/2)),ceil(L/2):end-(floor(L/2)))-F);
    g = abs(F-Gp)>umbral;
    G = g.*Gp + not(g).*F;    
end;
end

