function [Tf_normal_form, coeffs_N, coeffs_D] = tf_from_sym_to_normal_form(Tf_sym_form)
% Given a sym Transfer function, return a transfer function in normal form
% and coeffs of denominator.

[N, D] = numden(Tf_sym_form);
coeffs_N = (sym2poly(N))/10e16;
coeffs_D = (sym2poly(D))/10e16;

Tf_normal_form = tf(coeffs_N, coeffs_D);

end