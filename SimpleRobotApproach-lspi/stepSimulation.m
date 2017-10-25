function next_robot_pos = stepSimulation(current_robot_pos, l_action)

    if(l_action == 1)
        actions = [0.1 0];
    elseif(l_action == 2)
        actions = [-0.1 0];
    elseif(l_action == 3)
        actions = [0 0.1];
    elseif(l_action == 4)
        actions = [0 -0.1];
    end
    
    % ˆÚ“®
    
    next_robot_pos = [current_robot_pos(1) + actions(1); current_robot_pos(2) + actions(2)];
    
end