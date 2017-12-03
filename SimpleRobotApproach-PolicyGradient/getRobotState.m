function state = getRobotState(goal_pos, robot_pos, robotang)

%@Šp“x‚Ì·‚ÌŒvZ
angle_d = goal_pos - robot_pos;
theta = atan2(angle_d(2),angle_d(1));
if theta > pi
    theta = theta - 2*pi;
elseif theta < -pi
    theta = theta + 2*pi;
end
state = [theta - robotang];
end