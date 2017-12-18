L = 20;
M = 2000;
T = 20;
gamma = 0.98;
alpha = 0.9;

N = 3; %(mu:1ŽŸŒ³, sigma:1ŽŸŒ³)


AvgR = [];
r =zeros(50,20);
for i=1:50
    fprintf('***********PHASE:%d************\n', i);
    [sigma, mu, AvgR] = PolicyGradient(L, M, T, N, gamma, alpha);
    r(i,:) = AvgR;
end
csvwrite('AvgR_xy.csv',r);
