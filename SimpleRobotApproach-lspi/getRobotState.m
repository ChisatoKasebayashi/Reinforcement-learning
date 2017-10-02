function state = getRobotState(goal_pos, robot_pos, l_action)

    if(l_action == 1)
        actions = [0.1 0];
    elseif(l_action == 2)
        actions = [-0.1 0];
    elseif(l_action == 3)
        actions = [0 0.1];
    else
        actions = [0 0];
    end
    
    % à⁄ìÆ
    robot_pos(1) = robot_pos(1) + actions(1);
    robot_pos(2) = robot_pos(2) + actions(2);
    
    %Å@ëäëŒãóó£ÇÃåvéZ
    r_x = goal_pos(1) - robot_pos(1);
    r_y = goal_pos(2) - robot_pos(2);
        
    state = [r_x; r_y];

end