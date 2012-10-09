% Alumno: Daniel Fernández Núñez
% G = palto(F,'basicoN')
% G = palto(F,'basicoS')
% G = palto(F,'basicoE')
% G = palto(F,'basicoO')
% G = palto(F,'elim','mmovil1')
% G = palto(F,'elim','mmovil2')
% G = palto(F,'elim','mmovil3')
% G = palto(F,'bordesh',umbral)
% G = palto(F,'bordesv',umbral);
function [G] = palto(F,filtro,opt)

F = double(F);
if (strcmp(filtro,'basicoN'))
    H = ones(3);
    H(2,2) = -2;
    H(3,:) = -1;
    G = conv2(F,H);
    G = G(2:end-1,2:end-1);
elseif (strcmp(filtro,'basicoS'))
    H = ones(3);
    H(2,2) = -2;
    H(1,:) = -1;
    G = conv2(F,H);
    G = G(2:end-1,2:end-1);
elseif (strcmp(filtro,'basicoE'))
    H = ones(3);
    H(2,2) = -2;
    H(:,1) = -1;
    G = conv2(F,H);
    G = G(2:end-1,2:end-1);
elseif (strcmp(filtro,'basicoO'))
    H = ones(3);
    H(2,2) = -2;
    H(:,3) = -1;
    G = conv2(F,H);
    G = G(2:end-1,2:end-1);
elseif (strcmp(filtro,'elim'))
    G = F - pbajo(F,3,opt);
elseif (strcmp(filtro,'bordesh'))
    Fp = zeros(length(F(:,1))+2,length(F(1,:))+2);
    Fp(2:end-1,2:end-1) = F;
    G = 2 * F - Fp(2:end-1,1:end-2) - Fp(2:end-1,3:end);
    B = (G>=opt)*255;
    G = B;
elseif (strcmp(filtro,'bordesv'))
    Fp = zeros(length(F(:,1))+2,length(F(1,:))+2);
    Fp(2:end-1,2:end-1) = F;
    G = 2 * F - Fp(1:end-2,2:end-1) - Fp(3:end,2:end-1);
    B = (G>=opt)*255;
    G = B;
end;
end

