function [angle pos] = setWorldState( g_robot_pos, g_robot_angle, action, step )
angle = g_robot_angle + action;
pos = [g_robot_pos(1)+step*cos(angle) g_robot_pos(2) + step*sin(angle)];
end