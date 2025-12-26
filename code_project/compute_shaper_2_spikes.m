function [shaper] = compute_shaper_2_spikes(zeta, omega)
    %equazioni (6) articolo Singer per il calcolo di A_2, t_2
    %caso input shaper a 2 inpulsi di cui uno iniziale e uno per il controllo
    
    A_1=1;
    t_1=0;
    
    K = exp(-pi*zeta./(sqrt(1-zeta.^2)));
    Delta_T = pi./(omega.*sqrt(1-zeta.^2));

    norm = 1 + K;

    A_1 = A_1/norm;

    A_2 = K/norm;
    t_2 = Delta_T;

    shaper = [A_1, A_2;
              t_1, t_2];
    
end 