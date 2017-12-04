function [sigma, mu] = NaturalActorCritic(L, M, T, N, ganma, alpha)
robotpos = [0, 0];                                             %�V�~�����[�^�̏����l
MaxAng = deg2rad(180);
MinAng = deg2rad(0);

mu = rand(N-1, 1)-0.5;
sigma = rand*L;

Z = zeros(M, N);
q = zeros(M, 1);
w = zeros(N, 1);

for l=1:L
    dr = 0;
    
    for m=1:M
        %min_x = -0.5;
        %max_x = 0.5;
        %min_y = 0.3;
        %max_y = 0.9;
        %goal_pos_x = round((max_x-min_x).*rand()+min_x, 1);
        %goal_pos_y =  round((max_y-min_y).*rand()+min_y, 1);
        %goalpos = [goal_pos_x, goal_pos_y];
        
        goalpos = [0, 0.8];
        robotang = deg2rad(0);
        
        for t=1:T
            %��Ԃ̏�����
            state = zeros(N-1,1);
            
            %���{�b�g�̏�Ԋϑ�
            state = getRobotState(goalpos, robotpos, robotang);
            
            %�s���̑I��
            action = randn*sigma + mu'*state;
            action = min(action, MaxAng);
            action = max(action, MinAng);
            
            %�s���̎��s
            robotang = stepSimulation(state, action);
            
            %�L�^�H�I
            states(:,t) = state;
            actions(t) = action;
            rewards(m, t) = getReward(state);
            dr = dr + gamma^(t-1)*rewards(m,t);
            
            if( and(m==M,1) )
                plotSimulation(goalpos, robotpos, robotang, strcat('Policy=',num2str(l),' Episode=',num2str(m)));
                figure(2);
                if t==1
                    clf;
                else
                    hold on;
                    bar(t,rewards(m, t));
                    xlim([0 T]);
                    pause(0.1);
                end
            end
        end
        
        for t=1:T
            %mu�Ɋւ�����z�̌v�Z
            der(1, N-1) = (actions(t) - mu'*states(:, t))*states(:, t)/(sigma^2);
            %sigam�Ɋւ�����z�̌v�Z
            der(N) = ((actions(t)-mu'*states(:,t))^2-sigma^2)/(sigma^3);
            %�f�U�C���s��Z�y�ѕ�V�x�N�g��q
            Z(m, :) = Z(m, :) + gamma^(t-1)*der;
            q(m) = q(m) + gamma^(t-1)*(rewards(m,t));
        end
    end
    % r - V(s1)
    q = q- dr/M;
    
    %�ŏ����@��p���ăA�h�o���e�[�W�֐��̃��f���p�����[�^�𐄒�
    Z(:, N) = ones(M, 1);
    w = pinv(Z'*Z)*Z'*q;
    
    %w��p���ă��f���p�����[�^���X�V
    mu = mu + alpha*w(1:N-1);
    sigma = sigma + alpha*w(N);
    
    disp(strcat('Episode:',num2str(l),' /Max:',num2str(max(max(rewards))), ' /Min:', num2str(min(min(rewards))), ' /Mean:', num2str(mean(mean(rewards)))));
end
end