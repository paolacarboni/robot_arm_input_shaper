function [om, om2] = find_natural_frequencies(b)
    % Compute natural frequencies
    % INPUT: 
    %   n_e: number of frequencies
    %   b  : solutions of characteristic equation
    %
    % OUTPUT:
    %     om: natural frequencies
    %    om2: natural frequencies squared


    global L base h J0 E rho Mp Jp J I EI

    om2 = b.^4*EI/rho;  % square of the eigenfrequencies om_i^2(in rad)
    om = sqrt(om2);     % eigenfrequencies

end