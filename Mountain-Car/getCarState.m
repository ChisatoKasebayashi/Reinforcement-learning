function [state] = getCarState(x, dx, a)
    del_t = 0.1; %シミュレーションステップステップ
    m = 0.2;
    k = 0.3;

        vel = dx + ( -9.8*m*cos(3*x) + a/m - k*dx)*del_t;
        pos = x + vel*del_t;
        
        state = [pos; vel];
%state = transpose(s);
%disp(state);
% s = transpose(x, dx)
    
end