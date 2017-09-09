function theta = LeastSquaresPolicyIteration(L, M, T, B) % L:�������� M:�G�s�\�[�h T:�X�e�b�v B:�K�E�X�֐��̌�
    
    right = [0.1 0];
    left = [-0.1 0];
    foward = [0 0.1];
    actions = [right; left; foward];          % �s���̌��
    nactions = 3;                             % �s���̐�
    ganmma = 0.90;                            % ������ 0.8
    epsilon = 0.01;                            % ��-greedy�̕ϐ� 0.2 �������Ȃ��
    sigma = 0.8;                              % �K�E�X�֐��̕� 0.5
    
    %�S�[���n�_
    goal_pos_x = 0.6;
    goal_pos_y = 1.0;

    goal_pos = [goal_pos_x goal_pos_y];
    
    % �f�U�C���s��X �x�N�g��r�̏�����
    X = zeros(M*T, B*nactions);
    r = zeros(M*T, 1);
    
    % ���ڂ̃G�s�\�[�h�̏����l
    f_state = [0.6; 0];
    
    % �K�E�X�֐��̒��S�s��@36��3
    t=[-1.2, -0.35,0.5];
    y=[-1.5, -0.5, 0.5, 1.5];
    center = [];
    for k=1:3
        for j=1:4
            c = [t(k), y(j)];
            center = [center;c];
        end
    end
    
    % ���f���p�����[�^�̏�����
    theta = zeros(B*nactions, 1);
   
    MaxR=[];
    AvgR=[];
    Dsum=[];
    
    % ��������
    for l=1:L
        dr = 0;
        
        % �W�{
        for m=1:M
            
            disp('*************EPISODE*************');
            state = f_state;
            disp([l m]);
            for t=1:T+1
                % ���(�ʒu ���x �s��)�̊ϑ�
                dist = sum((center - repmat(state',B,1)).^2,2);            % dist:36x1
                %test = repmat(state',B,1);
                
                %==========================================
                % ���� 
                phis = exp(-dist/2/(sigma.^2));                           % phis:36x1
                
                % ���݂̏�ԂɊւ�����֐�
                Q = phis'*reshape(theta, B, nactions);                     % Q:1x3
                %==========================================
                
                % ����
                policy = zeros(nactions,1);
                
                % ��greedy
                [v, a] = max(Q);                                           % [maxnum index] = max(Q)
                policy = ones(nactions, 1)*epsilon/nactions;
                policy(a) = 1-epsilon+epsilon / nactions;
                
            %�s���I��
            ran = rand;
            if(ran < policy(1))
                l_action = 1;
            elseif(ran < policy(1) + policy(2))
                l_action = 2;
            else
                l_action = 3;
            end
           
            if( and(m==M,1) )
                stepSimulation(state, goal_pos, actions(l_action));
            end
            
            %�s���̎��s
            x = state(1);
            y = state(2);
            test = actions(l_action);
            state = getRobotState(goal_pos,state,actions, l_action);
            %disp(state);
            
            
    %---------------------------------------    
            if t>1
                aphi = zeros(B*nactions, 1);
                for a=1:nactions
                    aphi = aphi + getPhi(state, a, center, B, sigma, nactions)*policy(a);
                end
                pphi = getPhi(pstate, paction, center, B, sigma, nactions);
                
                %(M*T)*B�f�U�C���s��w, M*T�����x�N�g��r
                X( T*(m-1)+t-1, :) = (pphi - ganmma * aphi)';
                r( T*(m-1)+t-1 ) = getReward(goal_pos, state);
                dr = dr + r(T*(m-1) + t-1) *ganmma ^(t-1);
            end
            paction = l_action;
            pstate = state;
        end
    end
    
    %�����]��
    theta = pinv(X'*X)*X'*r;
    disp(theta);
    
    %result = sprintf('%d)Max=%.2f Arg=%.2f Dsum=%.2f\n',l, max(r), mean(r), dr/M);
    %disp([num2str(l) +')Max='+num2str(max(r)) 'Avg='+num2str(mean(r)) 'Dsum='+num2str(dr/M)]);
    disp([l max(r) mean(r) dr/M]);
    MaxR=[MaxR max(r)];
    AvgR=[AvgR mean(r)];
    Dsum=[Dsum dr/M];
    end
    figure(2);
    subplot(3,1,1)
    plot(1:L,MaxR)
    subplot(3,1,2)
    plot(1:L,AvgR)
    subplot(3,1,3)
    plot(1:L,Dsum)
end

