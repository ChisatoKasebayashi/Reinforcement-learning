function [angle pos] = setWorldState( g_robot_pos, g_robot_angle, action, step )
angle = g_robot_angle + action;
pos = [0.2*g_robot_pos(1) + step*cos(g_robot_angle) 0.2*g_robot_pos(2) + step*sin(sin(g_robot_angle))];
end