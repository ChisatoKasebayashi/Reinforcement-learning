function state = getRobotState(goal_pos, robot_pos, robotang)

    %Å@äpìxÇÃç∑ÇÃåvéZ
    relative_x = goal_pos(1) - robot_pos(1);
    relative_y = goal_pos(2) - robot_pos(2);
    theta = atan2(relative_y,relative_x);
    state = [theta - robotang];
end