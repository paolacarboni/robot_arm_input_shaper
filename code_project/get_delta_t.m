function [delta_t] = get_delta_t(ph_p_zero, om, z, tau_t)
%get_delta_t: it returns the delta_i(t) functions
% Given ph_p_zero [vector], omega [vector], zeta [vector], tau_t [syms function]
% it returns the delta(t) functions, which are calculated
% through the transfer function G(s) = delta(s)/tau(s)

syms t s

tau_s = laplace(tau_t, t, s);

    delta_t = [];
    for i=1:length(ph_p_zero)
        % Let's define the transfer function G = delta(s)/tau(s)
        num = ph_p_zero(i);
        den = s^2+2*om(i)*z(i)*s+om(i)^2;
        G_i = num/den;
        delta_i_s = G_i*tau_s;
        delta_i_t = ilaplace(delta_i_s, s, t);
        delta_t = [delta_t; delta_i_t];
    end
end