function state = getPolarCoordinates(l_goal_pos)
r = sqrt(l_goal_pos.x^2 + l_goal_pos.y.^2);
theta = atan2(l_goal_pos.y, l_goal_pos.x);

state = [(sin(theta)+1)/2; (cos(theta)+1)/2];
end