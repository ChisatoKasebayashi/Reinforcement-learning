function [sigma, mu] = PolicyGradient(L, M, T, N, gamma, alpha)
robotpos = [0, 0];                                             %�V�~�����[�^�̏����l
MaxAng = deg2rad(180);
MinAng = deg2rad(0);


mu = rand(N-1, 1)-0.5;
sigma = rand*10;

MaxR=[];
AvgR=[];
Dsum=[];

%��������
for l=1:L
    dr = 0;
    rand();
    
    %�W�{
    for m=1:M
        drs(m) = 0;
        der(m, :) = zeros(1,N);
        
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
            
            robotang = stepSimulation(state, action);
            state = getRobotState(goalpos, robotpos, robotang);
            
            %����mu�Ɋւ�����z�̌v�Z
            der(m, 1:N-1) = der(m, 1:N-1) + ((action - mu'*state)*state/(sigma.^2))';
            
            %�W���΍�sigma�Ɋւ�����z�̌v�Z
            der(m, N) = der(m, N) + ((action-mu'*state).^2-sigma.^2)/(sigma.^3);
            
            %��������V�a�̌v�Z
            rewards(m, t) = getReward(state);
            drs(m) = drs(m) + gamma^(t-1)*rewards(m, t);
            dr = dr + gamma^(t-1)*rewards(m, t);
            %�s���̎��s
            if( and(m==M,l==L) )
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
    end
    
    %�ŏ����U�x�[�X���C�����v�Z
    b = drs * diag(der*der') / trace(der*der');
    
    %���z�𐄒�
    derJ = 1/M * ((drs-b) * der)';
    
    %���f���p�����[�^���X�V
    mu = mu + alpha *derJ(1:N-1);
    sigma = sigma + alpha * derJ(N);
    
    disp(strcat('Episode:',num2str(l),' /Max:',num2str(max(max(rewards))), ' /Min:', num2str(min(min(rewards))), ' /Mean:', num2str(mean(mean(rewards)))));
    MaxR=[MaxR max(max(rewards))];
    AvgR=[AvgR mean(mean(rewards))];
    Dsum=[Dsum dr/M];
end
figure(4);
subplot(3,1,1)
plot(1:L,MaxR)
title('�ő��V');
subplot(3,1,2)
plot(1:L,AvgR)
ylim([-1.8 -1])
title('���ϕ�V');
subplot(3,1,3)
plot(1:L,Dsum)
title('������V');
end