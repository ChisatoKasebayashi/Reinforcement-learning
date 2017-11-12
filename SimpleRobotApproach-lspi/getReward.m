function [reward] = getReward(state, robot, goal)
    
    dist = sqrt((state(1).^2 + state(2).^2));
    angle_d = -abs(rad2deg(goal(3) - robot(3)));
    reward = -dist + angle_d/360;

end