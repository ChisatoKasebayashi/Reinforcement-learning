L = 20;
M = 200;
T = 100;
gamma = 0.99;
alpha = 0.9;

N = 2; %(mu:2����, sigma:1����)

[mu, sigma] = PolicyGradient(L, M, T, N, gamma, alpha);

