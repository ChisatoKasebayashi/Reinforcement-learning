function [reward] = getHardReward(state, robot, goal, goal_area)
    
    dist = sqrt((state(1).^2 + state(2).^2));
    angle_d = goal(3) - robot(3);
    if angle_d > pi
        angle_d = angle_d - 2*pi;
    elseif angle_d < -pi
        angle_d = angle_d + 2*pi;
    end
    
    if (dist < goal_area) && abs(rad2deg(angle_d)) < 5
        reward = 0;
        disp('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
    else
        reward = -1;
    end
end