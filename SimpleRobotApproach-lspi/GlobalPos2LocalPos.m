function [local_goal_pos] = GlobalPos2LocalPos(global_goal, global_robot)
    trans = [cos(global_robot(3)), sin(global_robot(3)); -sin(global_robot(3)), cos(global_robot(3))];
    global_goal_pos = [global_goal(1); global_goal(2)];
    global_robot_pos = [global_robot(1); global_robot(2)];
    local_goal_pos = transpose(trans)*(global_goal_pos - global_robot_pos);
end