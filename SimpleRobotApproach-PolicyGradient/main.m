L = 30;
M = 2500;
T = 15;
gamma = 0.5;
alpha = 0.6;

N = 3; %(mu:1ŽŸŒ³, sigma:1ŽŸŒ³)

[sigma, mu] = PolicyGradient(L, M, T, N, gamma, alpha);

