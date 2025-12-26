function [conv_t, Conv_s, Shaper_s] = convolve_u_with_shaper(u_t, input_shaper)
%convolve_u_shaper: it returns the shaped command in time domain
%   Given a command function u_t in time domain (ex. u_t = heaviside(t)) and an input shaper in matrix form [Aj; tj],
% the function calculates the convolution of the two in the Laplace domain
% and then returns the final shaped command in the time domain 

syms t s


[~, cols_IS] = size(input_shaper);

shaper_t = 0;
for i=1:1:cols_IS
    shaper_t = shaper_t+ input_shaper(1, i)*dirac(t-input_shaper(2, i));
end

% Compute Laplace transform of u_t and shaper_t
U_s = laplace(u_t, t, s);
Shaper_s = laplace(shaper_t, t, s);

%Compute convolution in Laplace domain
Conv_s = U_s*Shaper_s;

% Convolution in time domain 
conv_t = ilaplace(Conv_s, s, t);
end