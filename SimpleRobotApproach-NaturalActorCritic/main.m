L = 20;
M = 2000;
T = 20;
gamma = 0.99;
alpha = 1;

N = 2; %(mu:1ŽŸŒ³, sigma:1ŽŸŒ³)

[mu, sigma] = NatualActorCritic(L, M, T, N, gamma, alpha);

