L = 20;
M = 2000;
T = 15;
gamma = 0.65;
alpha = 0.9;

N = 3; %(mu:1ŽŸŒ³, sigma:1ŽŸŒ³)


AvgR = [];
r =[]
%for i=1:30
%    fprintf('***********PHASE:%d************\n', i);
    [sigma, mu, AvgR] = PolicyGradient(L, M, T, N, gamma, alpha);
    r(i,:) = AvgR;
    %fprintf('*************%d**************\n',i);
%end
%csvwrite('AvgR_xy.csv',r);
