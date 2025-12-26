function [t, state]  = solve_non_lin_model2(phi, par,  theta_des, K_p, K_d, F, max_time)

global L base h J0 E rho Mp Jp J I EI 
% INPUT : 
%   phi : column vector of sym functions
%   u : scalar sym function 
%   F: equivalent-spring constant matrix (only diag components)

% csi = x/L
% phi = eigenfunctions, as many as n_e
% beta = L*gamma
% rho_v = rho_l/A
% I0 joint actuator inertia = J0 (in matlab)
% J0 link inertia relative to the joint = I (in matlab)
% mb = link mass
A= base*h;

n_e = length(phi);

mb = L*rho; %massa link (nb: rho densita' lineare)

phi_fun = matlabFunction(phi, Vars=par); 
phi_e = phi_fun(1);
phi_p =diff(phi_fun, par); %derivative of phi
phi_p_e = double(vpa(subs(phi_p, par, 1)));
d2_phi_fun = matlabFunction(diff(phi, par, 2));

% workaround to compute diff of theta_des
syms temp
dtheta_des = eval(['@(temp)' char(diff(theta_des(temp)))]);


% parameters computation

integrando_sigma = @(csi) phi_fun(csi).*(ones(n_e, 1)*csi);

sigma = rho * L^2* integral(integrando_sigma, 0, 1, 'ArrayValued',true); % vettore da 1, ... n_e

integrando_k = @(csi) d2_phi_fun(csi).^2;

K = EI /L^3 * integral(integrando_k, 0, 1, 'ArrayValued',true);

% Computation of matrix B

%b11 depends from the state, computed in non_lin_model
b1j = Mp*L*phi_e+ Jp*phi_p_e + sigma; %j=2,3, , n_e+1

bii = ones(n_e, 1) * mb + Mp*phi_e.^2 + Jp*phi_p_e.^2; % i= 2, ..., n_e+1
bij = (Mp*(phi_e*phi_e') + Jp*(phi_p_e*phi_p_e')) .* (ones(n_e)-eye(n_e));  %i, j = 2, ..., n_e+1, i!=j prodotto finale usato per escludere elementi diagonali
bij_full = diag(bii) + bij;
% B=[b11, b1j';
%    b1j, bij_full];


disp(sprintf('\nStart sol ode non-lin-model...'))
tic
% Solution of system
[t, state] = ode45(@(t,state) non_lin_model(t, state,K, F,  theta_des, dtheta_des, Mp, phi_e, n_e, b1j, bij_full, J, K_p, K_d), [0 max_time], zeros( 2*(n_e+1),1));
time_ode=toc;
disp(sprintf('End sol ode non-lin-model \nComputation  time: %.2f sec', time_ode))

end

