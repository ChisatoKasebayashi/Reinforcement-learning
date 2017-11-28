function [reward] = getdistReward(state, robot, goal)
    
    dist = sqrt((state(1).^2 + state(2).^2));
    reward = -dist;

end