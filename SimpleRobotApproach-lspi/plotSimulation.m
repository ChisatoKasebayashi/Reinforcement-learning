function plotSimulation(robot, goal_position, goal_area, goal_direction, Title) % goal_pos,state,actions(action)

figure(1);
clf;
hold on;

%whitebg(field,[0 1 0])

t = title(Title);
set(t,'FontSize',16);

xlim([-0.8 0.8]);
ylim([-0.3 1.3]);
axis square;

% 目的地の描画
g_radii = goal_area;
viscircles(goal_position,g_radii);
c_goal = [goal_position(1) goal_position(2)];
g_goal = [goal_position(1) + cos(goal_direction) goal_position(2) + sin(goal_direction)];
line_goal = [c_goal;g_goal];
plot(line_goal([1,2],1),line_goal([1,2],2),'-','Color','r');


% ロボットの描画
r_radii = 0.03;
viscircles([robot(1) robot(2)],r_radii,'Color','k');
c_robot = [robot(1) robot(2)];
g_robot = [robot(1) + cos(robot(3)) robot(2) + sin(robot(3))];
%plot(a([c_robot(1) g_robot(1)],1),a([c_robot(2) g_robot(2)],2),'-')
line_robot = [c_robot;g_robot];
plot(line_robot([1,2],1),line_robot([1,2],2),'-','Color','k');

%saveas(field, 'simpleSim.jpg');

grid on;
pause(0.2);
end