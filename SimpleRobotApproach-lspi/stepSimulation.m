function next_robot_pos = stepSimulation(current_robot_pos, l_action)

    if(l_action == 1)
        actions = [1/2, sqrt(3)/2, -60];
    elseif(l_action == 2)
        actions = [0, 1, 0];
    elseif(l_action == 3)
        actions = [1/2, sqrt(3)/2, 60];
    end
    
    % ˆÚ“®
    
    next_robot_pos = current_robot_pos + actions;
    
end