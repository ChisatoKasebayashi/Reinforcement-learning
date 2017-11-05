function [local_goal_pos] = GlobalPos2LocalPos(global_goal_x, global_goal_y, global_robot_theta,global_robot_x,global_robot_y)
    trans = [cos(global_robot_theta), sin(global_robot_theta); -sin(global_robot_theta), cos(global_robot_theta)];
    global_goal_pos = [global_goal_x; global_goal_y];
    global_robot_pos = [global_robot_x; global_robot_y];
    local_goal_pos = transpose(trans)*(global_goal_pos - global_robot_pos);
end