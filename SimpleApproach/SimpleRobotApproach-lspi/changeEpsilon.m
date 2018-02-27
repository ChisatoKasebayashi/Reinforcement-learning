function [next_epsilon] = changeEpsilon(first_epsilon, policy)
f_ep = [0 first_epsilon];
p = [policy 0];
a = (f_ep(2)-p(2))/(f_ep(1)-p(1));
next_epsilon = a*(policy-1-f_ep(1)) + f_ep(2);
end