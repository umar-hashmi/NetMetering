function [X_out_alt] = efficiency_correction(X)

global e_ch e_dis

t1 = X;

if t1(1,1) >= 0
    X_out(1,1)= t1(1,1)*e_ch;
else
    X_out(1,1)=t1(1,1)/e_dis;
end

if X(1,2) >= 0
    X_out(1,2)= t1(1,2)*e_ch;
else
    X_out(1,2)=t1(1,2)/e_dis;
end

X_out_alt = X_out;