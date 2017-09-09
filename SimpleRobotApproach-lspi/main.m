function main
    
    % ÉpÉâÉÅÅ[É^
    robot_size = 0.05;
    goal_radius = 0.03;
    
    robot_pos_x = 0.6;
    robot_pos_y = 0.0;
    
    goal_pos_x = 0.6;
    goal_pos_y = 1.0;
    
    current_pos = [robot_pos_x-(robot_size/2) robot_pos_y-(robot_size/2) robot_size robot_size];
    goal_pos = [goal_pos_x goal_pos_y];
    action = 1;
    
    stepSimulation(current_pos, action, goal_pos);
    disp('test')
end