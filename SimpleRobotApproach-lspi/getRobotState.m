function state = getRobotState(goal_pos, state, actions, l_action)

    if(l_action == 1)
        actions = [0.1 0];
    elseif(l_action == 2)
        actions = [-0.1 0];
    else(l_action == 3)
        actions = [0 0.1];
    end
    
    x = state(1) + actions(1);
    y = state(2) + actions(2);
        
    state = [x; y];
%state = transpose(s);
%disp(state);
% s = transpose(x, dx)
    
end