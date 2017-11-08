function next_robot_pos = stepSimulation(robot, theta)
    
    next_theta = robot(3) + theta;
    % ˆÚ“®    
    if(theta ~= deg2rad(15))
        next_robot_pos = [robot(1)+(0.1*cos(next_theta)), robot(2)+(0.1*sin(next_theta)), next_theta];
    else
        % ù‰ñ‚ª15“x‚Ì‚Í‚»‚Ìê‚Åù‰ñ‚·‚é 
        next_robot_pos = [robot(1), robot(2), next_theta];
    end
    
end