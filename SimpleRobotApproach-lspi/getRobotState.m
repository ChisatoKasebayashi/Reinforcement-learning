function state = getRobotState(goal_pos, robot)

    %@‘Š‘Î‹——£‚ÌŒvZ
    relative_x = goal_pos(1) - robot(1);
    relative_y = goal_pos(2) - robot(2);
    theta = atan2(relative_y,relative_x) - robot(3);
    state = [relative_x; relative_y; theta];
end