function [reward] = getReward(state, robot, goal)
    
    dist = sqrt((state(1).^2 + state(2).^2));
    angle_d = goal(3) - robot(3);
    if angle_d > pi
        angle_d = angle_d - 2*pi;
    elseif angle_d < -pi
        angle_d = angle_d + 2*pi;
    end
    reward = -0.5*dist - 0.5*abs(angle_d)/pi;

end