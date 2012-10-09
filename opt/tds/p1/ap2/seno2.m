function [indices,sinv] = seno2(A,w,phi,nmin,nmax)
if nmin>=0 && nmax>=nmin
    L = 0:w:nmax;
    L = L(size(0:w:nmin,2):end);
elseif nmin<0 && nmax >=0
    Lr = 0:w:nmax;
    Ll = fliplr(-w:-w:nmin);
    L = [Ll,Lr];
elseif nmax<0 && nmin<=nmax
    L = 0:-w:nmin;
    L = L(size(0:-w:nmax,2):end);
    L = fliplr(L);
else
    error('Índices inválidos')
end
sinv = A*sin(L+phi);
sinv = sinv(:);
indices = L;
end
        