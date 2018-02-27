function [local_goal_x local_goal_y] = GlobalPos2LocalPos(global_goal_pos, global_robot_pos, global_robot_ang)
    trans = [cos(global_robot_ang), sin(global_robot_ang); -sin(global_robot_ang), cos(global_robot_ang)];
    global_goal_pos = [global_goal_pos(1); global_goal_pos(2)];
    global_robot_pos = [global_robot_pos(1); global_robot_pos(2)];
    local_goal_pos = trans*(global_goal_pos - global_robot_pos);
    local_goal_x = local_goal_pos(1);
    local_goal_y = local_goal_pos(2);
end