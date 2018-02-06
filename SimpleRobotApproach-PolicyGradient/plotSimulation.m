function plotSimulation(goalpos, robotpos, robotangle, goal_area,l,m,t) % goal_pos,robotangle,actions(action)

figure(1);
if(t==1)
    clf;
    text(robotpos(1),robotpos(2)-0.1,strcat('t = ',num2str(t)));
end
hold on;

%whitebg(field,[0 1 0])

tl = title(strcat('Policy=',num2str(l),' Episode=',num2str(m)));
set(tl,'FontSize',16);

xlim([-0.8 0.8]);
ylim([-0.3 1.3]);
axis square;


viscircles([goalpos(1) goalpos(2)], goal_area);
relative_ang = getRobotState(atan2(goalpos(2),goalpos(1)),robotangle);

r_radii = 0.04;
viscircles([robotpos(1) robotpos(2)],r_radii,'Color','k');
%text(robotpos(1)+0.1,robotpos(2),strcat(num2str(rad2deg(relative_ang)),'[deg]'));
sen=0.1;
c_robot = [robotpos(1) robotpos(2)];
g_robot = [robotpos(1) + sen*cos(robotangle) robotpos(2) + sen*sin(robotangle)];
%plot(a([c_robot(1) g_robot(1)],1),a([c_robot(2) g_robot(2)],2),'-')
line_robot = [c_robot;g_robot];
plot(line_robot([1,2],1),line_robot([1,2],2),'-','Color','k');

%saveas(field, 'simpleSim.jpg');

grid on;
pause(0.1);
if(t==15)
    image_name = strcat('Policy',num2str(l))
    saveas(gcf,image_name,'epsc')
end
end
