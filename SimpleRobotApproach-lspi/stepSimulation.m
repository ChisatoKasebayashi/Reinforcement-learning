function next_robot_pos = stepSimulation(robot, theta, action_label)
    
    next_theta = robot(3) + theta;
    % �ړ�    
    if(action_label < 4)
        next_robot_pos = [robot(1)+(0.1*cos(next_theta)), robot(2)+(0.1*sin(next_theta)), next_theta];
    else
        % ���x��4�̃A�N�V�����̎��͂��̏�Ő��񂷂� 
        next_robot_pos = [robot(1), robot(2), next_theta];
    end
    
end