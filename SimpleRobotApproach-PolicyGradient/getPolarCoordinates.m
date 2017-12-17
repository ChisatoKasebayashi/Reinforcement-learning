function state = getPolarCoordinates(l_goal_pos)
r = sqrt(l_goal_pos.x^2 + l_goal_pos.y.^2);
theta = atan2(l_goal_pos.x, l_goal_pos.y);
state = [r; theta];
end