function [local_goal_pos] = GlobalPos2LocalPos(global_goal_x, global_goal_y, global_robot_theta)
    trans = [cos(global_robot_theta), sin(global_robot_theta); -sin(global_robot_theta), cos(global_robot_theta)];
    global_pos = [global_goal_x; global_goal_y];
    local_pos = trans * global_pos;
    local_goal_pos = transpose(local_pos);
end