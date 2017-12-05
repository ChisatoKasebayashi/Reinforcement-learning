function plotSimulation(goalpos, robotpos, robotangle, Title) % goal_pos,robotangle,actions(action)

figure(1);
clf;
hold on;

%whitebg(field,[0 1 0])

t = title(Title);
set(t,'FontSize',16);

xlim([-0.8 0.8]);
ylim([-0.3 1.3]);
axis square;

% �ړI�n�̕`��
viscircles([goalpos(1) goalpos(2)],0.03);
%text(goal(1)+0.1,goal(2),strcat(num2str(rad2deg(goal(3))),'��'));
%c_goal = [goal(1) goal(2)];
%g_goal = [goal(1) + cos(goal(3)) goal(2) + sin(goal(3))];
%line_goal = [c_goal;g_goal];
%plot(line_goal([1,2],1),line_goal([1,2],2),'-','Color','r');

relative_ang = getRobotState(atan2(goalpos(2),goalpos(1)),robotangle);

% ���{�b�g�̕`��
r_radii = 0.04;
viscircles([robotpos(1) robotpos(2)],r_radii,'Color','k');
text(robotpos(1)+0.1,robotpos(2),strcat(num2str(rad2deg(relative_ang)),'[deg]'));
c_robot = [robotpos(1) robotpos(2)];
g_robot = [robotpos(1) + cos(robotangle) robotpos(2) + sin(robotangle)];
%plot(a([c_robot(1) g_robot(1)],1),a([c_robot(2) g_robot(2)],2),'-')
line_robot = [c_robot;g_robot];
plot(line_robot([1,2],1),line_robot([1,2],2),'-','Color','k');

%saveas(field, 'simpleSim.jpg');

grid on;
pause(0.2);
end