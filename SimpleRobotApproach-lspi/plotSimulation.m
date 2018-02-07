function stepSimulation(relative_position, robot_position, goal_position, action, l,m,t) % goal_pos,state,actions(action)

figure(1);
if(t==1)
    clf;
    text(robot_position(1),robot_position(2)-0.1,strcat('t = ',num2str(t)));
end
hold on;

%whitebg(field,[0 1 0])

%t = title(Title);
%set(t,'FontSize',16);

xlim([-0.8 0.8]);
ylim([-0.3 1.3]);
axis square;
grid on;

% 目的地の描画
radii = 0.15;
viscircles(goal_position,radii);

% ロボットの描画
current_position = [transpose(robot_position)-[0.025, 0.025], 0.05, 0.05];
%rectangle('Position',current_position, 'FaceColor', 'k');
viscircles([robot_position(1) robot_position(2)],0.04,'Color','k');

%saveas(field, 'simpleSim.jpg');

%pause(0.2);
if(t==15)
    image_name = strcat('Policy',num2str(l),'.pdf')
    saveas(gcf,image_name)
end
end
