L = 20;
M = 200;
T = 40;
gamma = 0.99;
alpha = 1;

N = 3; %(mu:1����, sigma:1����)

[mu, sigma] = NaturalActorCritic(L, M, T, N, gamma, alpha);

