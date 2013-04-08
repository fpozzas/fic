function pulso=pulso_rectangular(L,N)

% Pulso rectangular

amplp = 1;
rangop=-L*N:L*N;

pulso=zeros(1,2*L*N + 1);
pulso(L*N+1:L*N+1+N-1)=amplp;
