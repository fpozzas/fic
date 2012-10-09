function [xn] = xn_triangular(L);

xn1 = 1:L;
xn2 = L-1:-1:1;
xn = [xn1 xn2]';
end

