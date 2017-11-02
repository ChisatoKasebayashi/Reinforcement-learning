function next_robot_pos = stepSimulation(robot, theta)
    
    next_theta = robot(3) + theta;
    % ˆÚ“®    
    next_robot_pos = [robot(1)+(0.1*cos(next_theta)), robot(2)+(0.1*sin(next_theta)), next_theta];
    
end