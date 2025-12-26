% Utility for report

syms a0 a1 a2 a3 a4 a5 
% 
r1= [1 a4 a2 a0];
r2= [a5 a3 a1 0];


% r1=[1 a2 a0]
% r2= [a3 a1 0]


a = [r1; r2];

for j = 1:1:length(r1)
    r_new=r1*0;
    for i=1:1:length(r1)-1
        r_new(i) = -simplify(det([a(j:j+1,1), a(j:j+1,i+1)])/a(j+1,1));

    end 
    a = [a; r_new];
end
a(:,1)