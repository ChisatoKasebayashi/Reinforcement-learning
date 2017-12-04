function state = getRobotState(goal_pos, robot_pos, robotang)

%@Šp“x‚Ì·‚ÌŒvŽZ
theta_g = atan2(goal_pos(2),goal_pos(1));

angle_d = theta_g - robotang;
if angle_d > pi
    angle_d = angle_d - 2*pi;
elseif angle_d < -pi
    angle_d = angle_d + 2*pi;
end
state = angle_d;
end