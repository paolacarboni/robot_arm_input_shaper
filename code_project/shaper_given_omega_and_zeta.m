function [conv_2_spike, conv_3_spike] = shaper_given_omega_and_zeta(om, z)
% INPUT:
%   om: vector of omega of the system
%   z : vector of zeta of the system
% OUTPUT:
% conv_2_spike: cell input shaper with 2 spikes (basic one)
% conv_3_spike: cell input shaper with 3 spikes (more robust one)


n_freq = length(om);

% creation of 2 cell arrays with on
input_shaper_2_spikes = cell(1, n_freq);
input_shaper_3_spikes = cell(1, n_freq);
conv_2_spike = []; % convolution of all input shapers 2 spikes
conv_3_spike = []; % convolution of all input shapers 3 spikes (more robust)

for i=1:1:n_freq
     input_shaper_2_spikes{1, i} = compute_shaper_2_spikes(z(i), om(i));
     input_shaper_3_spikes{1, i} = compute_shaper_3_spikes(z(i), om(i));
     if i == 1
         conv_2_spike = input_shaper_2_spikes{1, i};
         conv_3_spike = input_shaper_3_spikes{1, i};
     else
         conv_2_spike = convolve_shapers(conv_2_spike, input_shaper_2_spikes{1, i});
         conv_3_spike = convolve_shapers(conv_3_spike, input_shaper_3_spikes{1, i});
     end
end

end