function [Tf_sym] = tf_from_normal_form_to_sym(Tf, s)
%Given transefer function in normal form, return a sym version

[Num,Den] = tfdata(Tf); 
Tf_sym = poly2sym(cell2mat(Num),s)/poly2sym(cell2mat(Den),s); % Mc in syms form
end