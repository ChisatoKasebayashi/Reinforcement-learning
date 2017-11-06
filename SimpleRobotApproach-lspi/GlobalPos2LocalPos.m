function [local_goal_pos] = GlobalPos2LocalPos(global_goal, global_robot)
    tmp_theta = global_robot(3) - deg2rad(90);
    trans = [cos(tmp_theta), sin(tmp_theta); -sin(tmp_theta), cos(tmp_theta)];
    global_goal_pos = [global_goal(1); global_goal(2)];
    global_robot_pos = [global_robot(1); global_robot(2)];
    local_goal_pos = transpose(trans)*(global_goal_pos - global_robot_pos);
end