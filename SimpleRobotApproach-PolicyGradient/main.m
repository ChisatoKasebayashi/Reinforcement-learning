L = 30;
M = 2500;
T = 20;
gamma = 0.98;
alpha = 0.9;

N = 3; %(mu:1����, sigma:1����)

[sigma, mu] = PolicyGradient(L, M, T, N, gamma, alpha);

