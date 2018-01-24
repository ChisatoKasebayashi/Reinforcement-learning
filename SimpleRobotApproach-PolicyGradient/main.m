L = 20;
M = 2500;
T = 15;
gamma = 0.5;
alpha = 0.6;

N = 3; %(mu:1����, sigma:1����)

AvgR = [];
r = [];
for i=1:30
    [sigma, mu,AvgR] = PolicyGradient(L, M, T, N, gamma, alpha);
    r = [r; AvgR];
    fprintf('*************%d**************\n',i);
end
csvwrite('AvgR_rtheta.csv',r);
