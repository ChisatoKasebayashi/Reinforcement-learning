function reward = getReward(state)
reward = -abs(sum(state.^2));
end