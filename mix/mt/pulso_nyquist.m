function pulso=pulso_nyquist(L,N)

% Pulso de Nyquist

amplp=1;
rangop=-L*N:L*N;

pulso = sin(pi * rangop / N);
pulso(1:L*N) = pulso(1:L*N) ./ (pi * rangop(1:L*N)/N);
pulso(L*N + 1) = 1;
pulso(L*N+2:end) = pulso(L*N+2:end) ./ (pi * rangop(L*N+2:end)/N);
pulso=pulso*amplp;