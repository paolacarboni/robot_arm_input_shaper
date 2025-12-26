function dstate = non_lin_model(t, state,K, F,  theta_des, dtheta_des, Mp, phi_e, n_e, b1j, bij_full, J, K_p, K_d)
%global K F theta_des K_p Mp phi_e n_e b1j bij_full J
%% initializing variables
theta = state(1); dtheta = state(2); delta = state(3:2+n_e); ddelta = state(3+n_e:2+2*n_e);
%vpa(theta_des(t))
u = K_p*( theta_des(t) - theta) + K_d*(double(dtheta_des(t)) - dtheta);
n1 = 2*Mp * dtheta * (phi_e'*delta) *  (phi_e'*ddelta);
n2 = -Mp * dtheta^2 * (phi_e * phi_e')*delta;

b11 = J + Mp*(phi_e'*delta)^2;

Delta_maiusc = bij_full - 1/b11 * (b1j*b1j');

D22 = inv(Delta_maiusc);
D12 = - 1/b11 * (D22 * b1j);
d11 = 1/ (b11 - b1j' * inv(bij_full) *b1j);

ddtheta = d11 * (-n1 + u)+ D12' * (-n2 - K.*delta - F .* ddelta);
dddelta = D12 * (-n1 + u) + D22 * (-n2 - K.*delta - F .* ddelta);
dstate = [dtheta; ddtheta; ddelta; dddelta];

end


