function stepSimulation(current_position, goal_position, action, Title) % goal_pos,state,actions(action)

figure(1);
clf;
hold on;

%whitebg(field,[0 1 0])

t = title(Title);
set(t,'FontSize',16);

xlim([0 1.2]);
ylim([-0.1 1.2]);
axis square;
grid on;

% �ړI�n�̕`��
radii = 0.03;
viscircles(goal_position,radii);

% ���{�b�g�̕`��
current_position = [transpose(current_position)-[0.025, 0.025], 0.05, 0.05];
rectangle('Position',current_position, 'FaceColor', 'k');

%saveas(field, 'simpleSim.jpg');

pause(0.2);
end