function [angle pos] = setWorldState( g_robot_pos, g_robot_angle, action, step )
angle = g_robot_angle + action;
pos = [step*cos(angle) step*sin(sin(angle))];
end