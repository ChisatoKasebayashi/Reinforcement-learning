function plotSimulation(robot, goal_position, goal_area, l,m,t) % goal_pos,state,actions(action)

figure(1);
if(t==1)
    clf;
    text(robot(1),robot(2)-0.1,strcat('t = ',num2str(t)));
end
hold on;

%whitebg(field,[0 1 0])

%t = title(Title);
%set(t,'FontSize',16);

xlim([-0.8 0.8]);
ylim([-0.3 1.3]);
axis square;

% 目的地の描画
g_radii = goal_area;
viscircles(goal_position,g_radii);

% ロボットの描画
r_radii = 0.03;
viscircles([robot(1) robot(2)],r_radii,'Color','k');
c_robot = [robot(1) robot(2)];
sen = 0.1;
g_robot = [robot(1) + sen*cos(robot(3)) robot(2) + sen*sin(robot(3))];
%plot(a([c_robot(1) g_robot(1)],1),a([c_robot(2) g_robot(2)],2),'-')
line = [c_robot;g_robot];
plot(line([1,2],1),line([1,2],2),'-','Color','k');

%saveas(field, 'simpleSim.jpg');

grid on;
%pause(0.1);
if(t==15)
    image_name = strcat('Policy',num2str(l),'.pdf')
    saveas(gcf,image_name)
end
end
