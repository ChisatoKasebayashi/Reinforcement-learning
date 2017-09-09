function stepSimulation(current_position, goal_position, action) % goal_pos,state,actions(action)
    clf
    hold on
    
    field = figure(1)
    
    %whitebg(field,[0 1 0])
    
    xlim([0 1.2])
    ylim([-0.1 1.2])
    axis square
    grid on
    
    % �ړI�n�̕`��
    radii = 0.03;
    viscircles(goal_position,radii)
    
    % ���{�b�g�̕`��
    current_position = [transpose(current_position)-[0.025 0.025] 0.05, 0.05]
    rectangle('Position',current_position, 'FaceColor', 'k');
    
    pause(0.1);
end