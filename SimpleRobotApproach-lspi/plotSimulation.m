function plotSimulation(relative_position, robot_position, robot_theta, goal_position, action, Title) % goal_pos,state,actions(action)

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
g_radii = 0.08;
viscircles(goal_position,g_radii);

% ロボットの描画
r_radii = 0.03;
viscircles(robot_position,r_radii,'Color','k');
if robot_theta == 0
    x = 0.0;
    y=robot_position:0.01:robot_position+0.03;
    plot(x, y, '-','Color', 'k','LineWidth',1.5);
elseif robot_theta == 60
    x = robot_position(1):0.01:robot_position(1)+0.03;
    y = 0.5*sin(deg2rad(robot_theta)) + (robot_position(2)-0.5*sin(deg2rad(robot_theta)))/(robot_position(1)-0.5*cos(deg2rad(robot_theta)))*(x-0.5*cos(deg2rad(robot_theta)));
    plot(x, y, '-','Color', 'k','LineWidth',1.5);
else
    x = robot_position(1)-0.02:0.01:robot_position(1);
    y = 0.5*sin(deg2rad(robot_theta)) + (robot_position(2)-0.5*sin(deg2rad(robot_theta)))/(robot_position(1)-0.5*cos(deg2rad(robot_theta)))*(x-0.5*cos(deg2rad(robot_theta)));
    plot(x, y, '-','Color', 'k','LineWidth',1.5);
end

%saveas(field, 'simpleSim.jpg');

grid on;
pause(0.2);
end