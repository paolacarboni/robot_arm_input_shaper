function [convolved_shaper] = convolve_shapers(A,B)
%convolve shapers: Given two input shapers A and B
%   it returns the convolution of the two shapers
[r_A, c_A] = size(A);
[r_B, c_B] = size(B);

convolved_shaper = [];
 for col_A=1:1:c_A
     for col_B=1:1:c_B
         amplitude = A(1, col_A)*B(1, col_B);
         time = A(2, col_A)+B(2, col_B);
         convolved_shaper = [convolved_shaper; amplitude, time];
     end
 end

convolved_shaper = sortrows(convolved_shaper, 2);
convolved_shaper = convolved_shaper';

end