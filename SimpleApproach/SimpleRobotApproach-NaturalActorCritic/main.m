L = 20;
M = 3000;
T = 20;
gamma = 0.95;
alpha = 0.8;

N = 3; %(mu:1����, sigma:1����)

[mu, sigma] = NaturalActorCritic(L, M, T, N, gamma, alpha);

