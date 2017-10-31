function plotSimulation(robot, goal_position, Title) % goal_pos,state,actions(action)

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
g_radii = 0.15;
viscircles(goal_position,g_radii);

% ロボットの描画
r_radii = 0.03;
viscircles([robot(1) robot(2)],r_radii,'Color','k');
c_robot = [robot(1) robot(2)];
g_robot = [robot(1) + cos(deg2rad(robot(3)+90)) robot(2) + sin(deg2rad(robot(3)+90))];
%plot(a([c_robot(1) g_robot(1)],1),a([c_robot(2) g_robot(2)],2),'-')
line = [c_robot;g_robot];
plot(line([1,2],1),line([1,2],2),'-');
%{
if robot(3) == 0
    x = 0.0;
    y=robot(1):0.01:robot(1)+0.03;
    plot(x, y, '-','Color', 'k','LineWidth',1.5);
elseif robot(3) == 30
    x = robot(1):0.01:robot(1)+0.03;
    y = 0.5*sin(deg2rad(robot(3))) + (robot(2)-0.5*sin(deg2rad(robot(3))))/(robot(1)-0.5*cos(deg2rad(robot(3))))*(x-0.5*cos(deg2rad(robot(3))));
    plot(x, y, '-','Color', 'k','LineWidth',1.5);
else
    x = robot(1)-0.02:0.01:robot(1);
    y = 0.5*sin(deg2rad(robot(3))) + (robot(2)-0.5*sin(deg2rad(robot(3))))/(robot(1)-0.5*cos(deg2rad(robot(3))))*(x-0.5*cos(deg2rad(robot(3))));
    plot(x, y, '-','Color', 'k','LineWidth',1.5);
end
%}

%saveas(field, 'simpleSim.jpg');

grid on;
pause(0.2);
end