function state = getRobotState(goal_pos, state, actions, l_action)

   
    actions(1) = actions(l_action, 1);
    actions(2) = actions(l_action, 2);
    
    x = state(1) + actions(1);
    y = state(2) + actions(2);
        
    state = [x; y];
%state = transpose(s);
%disp(state);
% s = transpose(x, dx)
    
end