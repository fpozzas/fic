function [ess] = error_est_estable(sist,entrada)
switch entrada
    case 'escalon'
        G = minreal(sist);
        kp = dcgain(G);
        ess = 1/(1+kp);
    case 'rampa'
        G = minreal('s'*sist);
        kv = dcgain(G);
        ess = 1/kv;
    case 'parabola'
        G = minreal('s'*('s'*sist));
        ka = dcgain(G);
        ess = 1/ka;
    otherwise
        display('error_est_estable : Entrada no valida');
        ess = -1;
end
