function theta = LeastSquaresPolicyIteration(L, M, T, B) % L:�������� M:�G�s�\�[�h T:�X�e�b�v B:�K�E�X�֐��̌�

%{
    actions = [-0.2, 0, 0.2];          % �s���̌��
    nactions = 3;                      % �s���̐�
    ganmma = 0.95;                     % ������
    epsilon = 0.2;                     % ��-greedy�̕ϐ�
    sigma = 0.5;                       % �K�E�X�֐��̕�
    
    % �f�U�C���s��X �x�N�g��r�̏�����
    X = zeros(M*T, B*nactions);
    r = zeros(M*T, 1);
    
    % ���ڂ̃G�s�\�[�h�̏����l
    f_state = [-0.5; 0; 0];
    
    % �K�E�X�֐��̒��S�s��@36��3
    t=[-1.2, -0.35,0.5];
    y=[-1.5, -0.5, 0.5, 1.5];
    center = [];
    for i=1:3
        for k=1:4
            for j=1:3
                c = [t(i), y(k) , actions(j)];
                center = [center;c];
            end
        end
    end
    
    % ���f���p�����[�^�̏�����
    theta = zeros(B*nactions, 1);
   
    % ��������
    for l=1:L
        dr = 0;
        rand('state',1);
        
        % �W�{
        for m=1:M
            disp('*************EPISODE*************');
            state = f_state;
            
            for t=1:T+1
                % ���(�ʒu ���x �s��)�̊ϑ�
                dist = sum((center - repmat(state',B,1)).^2,2);            % dist:36x1
                %test = repmat(state',B,1);
                
                %==========================================
                % ���� 
                phis = exp(-dist/2/(ganmma.^2));                           % phis:36x1
                
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
                action = 1;
            elseif(ran < policy(1) + policy(2))
                action = 2;
            else
                action = 3;
            end
            u(2) = actions(action);
            
            %�s���̎��s
            x = state(1);
            dx = state(2);
            state = getCarState(x,dx,actions(action));
            %disp(state);
            
            if( m==M )
            plotMountainCar(state(1));
            end
    %---------------------------------------    
            if t>1
                aphi = zeros(B*nactions, 1);
                for a=1:nactions
                    aphi = aphi + getPhi(state, a, center, B, sigma, nactions)*policy(a);
                end
                pphi = getPhi(pstate, paction, center, B, sigma, nactions);
                
                %(M*T)*B�f�U�C���s��w, M*T�����x�N�g��r
                X( T*(m-1)+t-1, :) = (pphi - ganmma * aphi)';
                r( T*(m-1)+t-1 ) = 1 / 1 + (0.5 - state(1).^2);
                dr = dr + r(T*(m-1) + t-1) *ganmma ^(t-1);
            end
            paction = action;
            pstate = state;
        end
    end
    
    %�����]��
    theta = pinv(X'*X)*X'*r;
    
    %result = sprintf('%d)Max=%.2f Arg=%.2f Dsum=%.2f\n',l, max(r), mean(r), dr/M);
    %disp([num2str(l) +')Max='+num2str(max(r)) 'Avg='+num2str(mean(r)) 'Dsum='+num2str(dr/M)]);
    disp([l max(r) mean(r) dr/M]);
    end
%}    

    actions = [-0.2, 0, 0.2];          % �s���̌��
    nactions = 3;                      % �s���̐�
    ganmma = 0.90;                     % ������ 0.8
    epsilon = 0.2;                     % ��-greedy�̕ϐ� 0.2 �������Ȃ��
    sigma = 0.8;                       % �K�E�X�֐��̕� 0.5
    
    % �f�U�C���s��X �x�N�g��r�̏�����
    X = zeros(M*T, B*nactions);
    r = zeros(M*T, 1);
    
    % ���ڂ̃G�s�\�[�h�̏����l
    f_state = [-0.5; 0];
    
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
        rand('state',1);
        
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
                action = 1;
            elseif(ran < policy(1) + policy(2))
                action = 2;
            else
                action = 3;
            end
            u(2) = actions(action);
            
            %�s���̎��s
            x = state(1);
            dx = state(2);
            state = getCarState(x,dx,actions(action));
            %disp(state);
            
            if( and(m==M,1) )
                plotMountainCar(state(1));
            end
    %---------------------------------------    
            if t>1
                aphi = zeros(B*nactions, 1);
                for a=1:nactions
                    aphi = aphi + getPhi(state, a, center, B, sigma, nactions)*policy(a);
                end
                pphi = getPhi(pstate, paction, center, B, sigma, nactions);
                
                %(M*T)*B�f�U�C���s��w, M*T�����x�N�g��r
                X( T*(m-1)+t-1, :) = (pphi - ganmma * aphi)';
                r( T*(m-1)+t-1 ) = 1 / (1 + (0.5 - state(1)).^2);
                dr = dr + r(T*(m-1) + t-1) *ganmma ^(t-1);
            end
            paction = action;
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

