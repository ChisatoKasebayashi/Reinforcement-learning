function [sigma, mu] = PolicyGradient(L, M, T, N, gamma, alpha)
robotpos = [0, 0];                                             %�V�~�����[�^�̏����l
MaxAng = deg2rad(180);
MinAng = deg2rad(0);


mu = rand(N-1, 1)-0.5;
sigma = rand*10;

%��������
for l=1:L
    dr = 0;
    rand();
    
    %�W�{
    for m=1:M
        drs(m) = 0;
        der(m, :) = zeros(1,N);
        
        min_x = -0.5;
        max_x = 0.5;
        min_y = 0;
        max_y = 0.8;
        
        goal_pos_x = round((max_x-min_x).*rand()+min_x, 1);
        goal_pos_y =  round((max_y-min_y).*rand()+min_y, 1);
        goalpos = [goal_pos_x, goal_pos_y];
        
        robotang = deg2rad(90);
        
        for t=1:T
            
            %��Ԃ̏�����
            state = zeros(N,1);
            
            %���{�b�g�̏�Ԋϑ�
            state = getRobotState(goalpos, robotpos, robotang);
            
            %�s���̑I��
            action = randn*sigma + mu'*state;
            action = min(action, MaxAng);
            action = max(action, MinAng);
            
            robotang = stepSimulation(state, action);
            state = getRobotState(goalpos, robotpos, robotang);
            %�s���̎��s
            if( and(m==M,1) )
                plotSimulation(goalpos, robotpos, robotang, strcat('Policy=',num2str(l),' Episode=',num2str(m)));
            end
            
            
            %����mu�Ɋւ�����z�̌v�Z
            der(m, 1:N-1) = der(m, 1:N-1) + ((action - mu'*state)*state/(sigma.^2))';
            
            %�W���΍�sigma�Ɋւ�����z�̌v�Z
            der(m, N) = der(m, N) + ((action-mu'*state).^2-sigma.^2)/(sigma.^3);
            
            %��������V�a�̌v�Z
            rewards(m, t) = getReward(state);
            drs(m) = drs(m) + gamma^(t-1)*rewards(m, t);
            dr = dr + gamma^(t-1)*rewards(m, t);
        end
    end
    
    %�ŏ����U�x�[�X���C�����v�Z
    b = drs * diag(der*der') / trace(der*der');
    
    %���z�𐄒�
    derJ = 1/M * ((drs-b) * der)';
    
    %���f���p�����[�^���X�V
    mu = mu + alpha *derJ(1:N-1);
    sigma = sigma + alpha * derJ(N);
    
end
end