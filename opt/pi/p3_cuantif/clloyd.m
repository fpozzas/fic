function [ mse,Qs,rk,tk ] = clloyd(L,S)
% [ mse,Qs,rk,tk ] = clloyd(L,S)
[tk,rk,mse,rd]=lloyds(S,zeros(1,L));
Qs = S;
for i=1:length(S)
    Qs(i) = rk(sum(S(i)>=tk)+1);
end
mse = mean((S-Qs).^2);
end
