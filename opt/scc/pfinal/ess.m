function [ error ] = ess(sys,type)
switch type
    case 'step'
        %G = minreal(sys);
        Kp = dcgain(sys);
        error = 1/(1+Kp);
    case 'ramp'
        G = minreal('s'*sys);
        Kv = dcgain(G);
        error = 1/Kv;
    otherwise
        disp('Fallo ess: Tipos posibles: ''step'', ''ramp''');
        error = -1;
end

