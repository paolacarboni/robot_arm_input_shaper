function [om,z] = omega_zeta_sys_given_denom_tf(D_W)
% Given:
%   D_W: the denominator of the transfer function of the system,
% Return:
%   omega and zeta of the system

A=roots(D_W);
omega = abs(A);
zeta = -real(A)./omega;

% prendo solo 1 volta ciascuna coppia di radici complesse e coniugate
om=[];
z = [];
for i = 1:1:length(A)
    if imag(A(i))>eps
        om = [om; omega(i)];
        z = [z; zeta(i)];
    end
end

end