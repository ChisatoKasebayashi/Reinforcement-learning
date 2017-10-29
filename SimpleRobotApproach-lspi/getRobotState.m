function state = getRobotState(goal_pos, robot_pos, robot_theta)

    %@‘Š‘Î‹——£‚ÌŒvZ
    relative_x = goal_pos(1) - robot_pos(1);
    relative_y = goal_pos(2) - robot_pos(2);
    
    theta = rad2deg(atan2(relative_x,relative_y));
        
    state = [relative_x; relative_y; theta];

end