function reward = getReward(state)
reward = -sqrt(sum(state.^2));
end