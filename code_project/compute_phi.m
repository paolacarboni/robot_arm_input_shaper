function [phi, phi_fun_rescaled, phi_L, ph_p_zero, csi] = compute_phi(n_e, b)

    global L base h J0 E rho Mp Jp J I EI

    syms csi

    phi_fun_rescaled = zeros(n_e, 1)*csi;

    x = [0:L/100:L]';

    for k = 1:n_e,
       [A(k),B(k),C(k),D(k)] = r2rmod(b(k));
       phi(:,k) = A(k)*sin(b(k)*x)+B(k)*cos(b(k)*x)+ ...
                  C(k)*sinh(b(k)*x)+D(k)*cosh(b(k)*x);
       phi_fun_rescaled(k) = A(k)*sin(b(k)*L*csi)+B(k)*cos(b(k)*L*csi)+ ...
                  C(k)*sinh(b(k)*L*csi)+D(k)*cosh(b(k)*L*csi);
    end

    
    ph_p_zero = (b'.*(A+C))';    % phi'_i(0)
    %phi_L = A.*sin(b*L)+B.*cos(b*L)+C.*sinh(b*L)+D.*cosh(b*L) % phi_i(L)
    phi_L = vpa(subs(phi_fun_rescaled, csi, 1), 4);


    % phi1= subs(phi_fun_rescaled(1), csi, 1/L*x)
    % figure(1)
    % plot(x, phi1)
    % figure(2)
    % plot(x, phi(:, 1))

end