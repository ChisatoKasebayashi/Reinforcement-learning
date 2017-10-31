function next_robot_pos = stepSimulation(robot, theta)
    
    next_theta = robot(3) + theta;
    % ˆÚ“®    
    next_robot_pos = [robot(1)+(0.1*cos(deg2rad(next_theta+90))), robot(2)+(0.1*sin(deg2rad(next_theta+90))), next_theta];
    
end