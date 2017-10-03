function state = getRobotState(goal_pos, robot_pos, l_action)

    %@‘Š‘Î‹——£‚ÌŒvZ
    r_x = goal_pos(1) - robot_pos(1);
    r_y = goal_pos(2) - robot_pos(2);
        
    state = [r_x; r_y];

end