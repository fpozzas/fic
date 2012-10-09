function [ C ] = codigo(L)

C4 = [ 0 0 ; 0 1 ; 1 0; 1 1 ];
C8 = [zeros(4,1) C4 ; ones(4,1) C4];
C16 =  [zeros(8,1) C8 ; ones(8,1) C8];
C32 =  [zeros(16,1) C16 ; ones(16,1) C16];

if L==4
    C = C4;
elseif L==8
    C = C8;
elseif L==16;
    C = C16;
elseif L==32;
    C = C32;
end
end