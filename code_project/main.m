clear all;
close all
clc;

global L base h J0 E rho Mp Jp J I EI

%**************************************************************************

%PARAMETERS DEFINITION

% Set all global variables:
% INPUTS:
%   L    = Lenght of link, 
%   base = base of link section, 
%   h    = heigth of link section, 
%   J0   = hub's inertia, 
%   E    = Young's modulus, 
%   rho  = density of the beam material, 
%   MP   = mass of payload,
%   Jp   = inertia of payload
%
% in addition compute the values of 
%   J    = Total Inertia of the beam
%   I    = Moment inertia of a rectangular beam
%   EI   = Flexural rigidity of the beam 
    

Set_Global_Vars(1.5, 0.05, 0.001, 1e-2, 69 * 1e9, 2.81, 0.3,  2/5*0.30*0.02^2); % 2.81 aluminium density

% Number of natural frequencies considered in the model
n_e = 1;

% Choose the numeber of spikes of the shaper (2 or 3)
num_spikes = 2;
% num_spikes = 3;

max_time = 15; % [s] max time simulations

% NOTE: if set generate_video_simulation = true, don't select plots before the
% end of computations
generate_video_simulation = true;

%**************************************************************************
% 1. Model parameters and functions computation

% Solutions of the characteristic equation: 
b = r2rfind(n_e)';

% Compute natural frequencies
[om, om2] = find_natural_frequencies(b);

% Compute 
%   phi (values 0-L), 
%   phi_fun_rescaled (values 0-1, used for non linear model), 
%   phi_L = phi(L)
%   ph_p_zero = phi'(0)
[phi, phi_fun_rescaled, phi_L, ph_p_zero, par] = compute_phi(n_e, b);

% Define matrix D and K, find coefficients zeta

% Define coefficients of Damping matrix D
d = ones(n_e, 1);

% Define coefficients of matrix K
k = om2;

% Define m_i mass vector
m = ones(n_e, 1);

% Find coefficients zeta, damping ratios
z = d./(2*m.*om);

for i=1:1:n_e
    if z(i) > 1
        disp('Overdamped case');
    elseif z(i) > 1-eps && z(i) < 1+eps
        disp('Critically damped case case')
    elseif z(i) > 0-eps && z(i) < 0+eps
        disp('Undamped case')
    elseif z(i) < 0
        disp('Exponential Growth')
    end
end

% prints
fprintf('Computed frequencies of robot dynamic: \n')
fprintf('\t omega %d = %.4f \n', [[1:1:n_e]; om'])

fprintf('\n\nComputed damping ratios of robot dynamic: \n')
fprintf('\t zeta %d = %.4f \n', [[1:1:n_e]; z'])

% parameter for plot representation
fig_ind = 1; 

%%
%**************************************************************************
% 2. LINEAR MODEL
% Define the control task for linear model 

% PID control
Kp = 10;

% 4.2 Convolve the input with input shaper, define the control as a P, solve
% the system with given control.

syms t
syms s


% Control the theta position 
referenceTitle= '\Theta_{des}';

% Desidered theta
% theta_des = heaviside(t-eps); % Regulation task to 1
theta_des = pi/2*heaviside(t-eps); % Regulation task to pi/2
%theta_des = dirac(t-eps) %Impulse

theta_des_s = laplace(theta_des); % in Laplace domain


input_t= theta_des;
input_s = theta_des_s;
Tf_theta_clamp_sym = (1/(J*s^2)+sum(ph_p_zero.^2./(s^2+2*z.*om*s+om.^2)));
Tf_input_sym = Tf_theta_clamp_sym;

% Funzioni di trasferimento Laplace

% Torque to output Transfer function - dynamic model
[Tf_dyn, coeffs_N_dyn, coeffs_D_dyn] = tf_from_sym_to_normal_form(Tf_input_sym);

% Funzione di trasferimento pid + dynamic model 

N_W = coeffs_N_dyn*Kp;
D_W = coeffs_D_dyn+[0 0 coeffs_N_dyn*Kp];
Tf_W =tf(N_W, D_W);


%***********************************************************
% Compute shaper of W
% omega and zeta of closed loop
[om_W, z_W] = omega_zeta_sys_given_denom_tf(D_W);


% prints
fprintf('\n\nComputed frequencies of closed loop: \n')
fprintf('\t omega_tilde %d = %.4f \n', [[1:1:length(om_W)]; om_W'])

fprintf('\n\nComputed damping ratios of closed loop: \n')
fprintf('\t zeta_tilde %d = %.4f \n', [[1:1:length(z_W)]; z_W'])

if num_spikes ==2
    shaper= shaper_given_omega_and_zeta(om_W, z_W);
else
    [~, shaper] = shaper_given_omega_and_zeta(om_W, z_W);
end

fprintf('\n\nInput shaper:\n')
disp(shaper)

disp(sprintf('\n\nComputing linear models (with and without IS)...'))
tic
% Convolve input step with input shaper
[shaped_input_t, shaped_input_s, Shaper_s] = convolve_u_with_shaper(input_t, shaper); 

% transform transfer function in sym form
Tf_syms = tf_from_normal_form_to_sym(Tf_W, s);

% overall transfer function in laplace domain
Try_no_shaper = Tf_syms;    % NO SHAPER
Try = Tf_syms*Shaper_s;     % WITH SHAPER

% output in laplace domain
Y_s_no_shaper = Try_no_shaper*input_s;  % NO SHAPER
Y_s = Try*input_s;                      % WITH SHAPER

% output in time domain
y_t_no_shaper = ilaplace(Y_s_no_shaper); % NO SHAPER
y_t = ilaplace(Y_s);                     % WITH SHAPER

time_computation = toc;
fprintf('Linear models computed \nComputation time: %.2f\n\n', time_computation)

error = theta_des-y_t; % commanded theta_c (u_t) - actual theta_c (y_t)
%%

% Grafico CONFRONTO
figure(fig_ind); fig_ind = fig_ind + 1; 
fplot(y_t_no_shaper, [0, max_time], 'LineWidth',2)
grid on;
hold on
fplot(y_t, [0, max_time], 'LineWidth',2)
hold on
fplot(input_t, [0, max_time], 'LineWidth',2)
hold on
legend( 'No Shaper', 'Shaper', 'Reference')
title(sprintf('Linear model response of P Controller - %d spikes', num_spikes))
xlabel('Time [s]')
ylabel('$\theta_c$ [rad]' ,'interpreter','latex')
hold off

% % Grafico ERRORE
% figure(fig_ind); fig_ind = fig_ind + 1; 
% fplot(error, [0, max_time],  'LineWidth', 2)
% grid on;
% title('ERRORE')
% xlabel('time [s]')
% ylabel('Amplitude')


% Grafico comparison reference
figure(fig_ind); fig_ind = fig_ind + 1; 
fplot(input_t, [0, max_time], 'LineWidth', 2);
grid on;
hold on;
fplot(shaped_input_t, [0, max_time],'LineWidth', 2);
title('Original and Pre-Shaped commands')
legend('Original reference', 'Shaped reference')
xlabel('time [s]')
ylabel('Amplitude')

% Video - simulation. 
% Don't select other plots while it is executing!

if generate_video_simulation
    generate_video('video_no_shaper.mp4', max_time, fig_ind, y_t_no_shaper); fig_ind = fig_ind + 1; 
    generate_video('video_shaper.mp4', max_time, fig_ind, y_t);fig_ind = fig_ind + 1;  
end 

%%
%**************************************************************************
% 3. NON LINEAR MODEL
%Kp = Kp; %same Kp of linear model
Kd= 0.2;

% Theta_des
% theta_des_nl = @(t) heaviside(t-eps);
theta_des_nl = matlabFunction(theta_des);

if Kd == 0
    type_controller = 'P';
else
    type_controller = 'PD';
end

% No input shaping - NL Model
[time_nl_no_is, y_nl_no_is] = solve_non_lin_model(phi_fun_rescaled, par,  theta_des_nl, Kp, Kd, d, max_time);

% Input shapers + NL Model
shaped_input_t  = convolve_u_with_shaper(theta_des_nl, shaper);
shaped_input_t = matlabFunction(shaped_input_t);
[time_nl_is, y_nl_is] = solve_non_lin_model(phi_fun_rescaled, par, shaped_input_t, Kp, Kd, d, max_time);


% Plots non-linear model
figure(fig_ind); fig_ind = fig_ind + 1; 
plot( time_nl_no_is, y_nl_no_is(:,1), time_nl_is, y_nl_is(:,1), time_nl_no_is, theta_des_nl(time_nl_no_is), 'LineWidth', 2)
grid on;
title(sprintf('Non linear model response of %s Controller - %d spikes' ,type_controller, num_spikes))
xlabel('Time [s]')
ylabel('$\theta_c$ [rad]' ,'interpreter','latex')
legend( 'No Shaper Response', 'Shaper Response','Reference')

if generate_video_simulation
    generate_video('video_no_shaper_nl.mp4', max_time, fig_ind,1, time_nl_no_is, y_nl_no_is(:,1)); fig_ind = fig_ind + 1; 
    generate_video('video_shaper_nl.mp4', max_time, fig_ind, 1, time_nl_is, y_nl_is(:,1));fig_ind = fig_ind + 1;  
end
