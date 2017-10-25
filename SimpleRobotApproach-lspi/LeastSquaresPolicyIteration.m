function theta = LeastSquaresPolicyIteration(L, M, T, B,center) % L:�������� M:�G�s�\�[�h T:�X�e�b�v B:�K�E�X�֐��̌�

right = [0.1 0];
left = [-0.1 0];
foward = [0 0.1];
back = [0,-0.1];
actions = [right; left; foward; back];          % �s���̌��
nactions = 3;                             % �s���̐�
ganmma = 0.95;                            % ������ 0.8
t_epsilon = 0.1;                            % ��-greedy�̕ϐ� 0.2 �������Ȃ��
sigma = 0.5;                              % �K�E�X�֐��̕� 0.5

%�S�[���n�_
goal_pos_x = 0.6;
goal_pos_y = 1.0;

goal_pos = [goal_pos_x goal_pos_y];

% �f�U�C���s��X �x�N�g��r�̏�����
X = []; %M*T,3*B
count = [];


% ���f���p�����[�^�̏�����
theta = zeros(B*nactions, 1);

MaxR=[];
AvgR=[];
Dsum=[];

% ��������
for l=1:L
    dr = 0;
    r = [];
    X = [];
    x = [];
    % �W�{
    for m=1:M
        
        %�S�[���n�_�̕ύX
        goal_pos_x = round(rand(), 1);
        goal_pos_y =  round(rand(), 1);
        goal_pos = [goal_pos_x goal_pos_y];
        
        % ���ڂ̃G�s�\�[�h�̏����l
        robot_pos = [];
        first_robot_pos = [0.6; 0];
        robot_pos = first_robot_pos;
        first_l_action = 4;
        f_state = getRobotState(goal_pos, first_robot_pos, first_l_action);
        
        % �Â����X�ɏ���������
        %t_epsilon = epsilon - m*epsilon/M;

        
        for t=1:T
            state = f_state;
            
            % ���(�ʒu ���x �s��)�̊ϑ�
            dist = sum((center - repmat(state',B,1)).^2,2);
            %test = repmat(state',B,1);
            
            %==========================================
            % ����
            phis = exp(-dist/2/(sigma.^2));
            
            % ���݂̏�ԂɊւ�����֐�
            Q = phis'*reshape(theta, B, nactions);
            %==========================================
            
            % ����
            policy = zeros(nactions,1);
            
            % ��greedy
            [v, a] = max(Q);
            t_epsilon = 1 - l*0.09;
            policy = ones(nactions, 1)*t_epsilon/nactions;
            policy(a) = 1-t_epsilon+t_epsilon / nactions;
            
            %�s���I��
            ran = rand;
            if(ran < policy(1))
                l_action = 1;
            elseif(ran < policy(1) + policy(2))
                l_action = 2;
            else
                l_action = 3;
            end
            
            if and(m==M,1)
                plotSimulation(state, robot_pos, goal_pos, actions(l_action),strcat('Policy=',num2str(l),' Episode=',num2str(m)));
            end
            
            %�s���̎��s
            robot_pos = stepSimulation(robot_pos,l_action);
            f_state = getRobotState(goal_pos, robot_pos, l_action);
            %---------------------------------------
            if t>1
                aphi = zeros(B*nactions, 1);
                for a=1:nactions
                    aphi = aphi + getPhi(state, a, center, B, sigma, nactions)*policy(a);
                end
                pphi = getPhi(pstate, paction, center, B, sigma, nactions);
                
                %(M*T)*B�f�U�C���s��w, M*T�����x�N�g��r
                x = [(pphi - ganmma * aphi)'];
                X = [X; x];
                r = [r,getReward(state)]; 
                if round(state(1),1) == 0 && round(state(2),1) == 0
                    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!');
                    disp('!!!!!!!!!!!GOAL!!!!!!!!!!!');
                    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!');
                    break;
                end
                
                if m==M
                    disp(strcat('Step=',num2str(t),', RobotPos(x,y):(',num2str(robot_pos(1)),', ',num2str(robot_pos(2)),')',', GoalPos(x,y):(',num2str(goal_pos_x),', ',num2str(goal_pos_y),'),', ' Reward=',num2str(r(length(r)))));
                    figure(2);
                    hold on;
                    bar(t,r(length(r)));
                    xlim([0 T]);
                    pause(0.1);
                    if t==T
                        clf(figure(2));
                    end
                end
                %dr = dr + r *ganmma ^(t-1);
            end
            paction = l_action;
            pstate = state;
       
            if and(t==T,m==M)
                disp('*************EPISODE*************');
            end
        end
    end
    
    %�����]��
    theta = pinv(X'*X)*X'*r';
    MaxR=[MaxR max(r)];
    AvgR=[AvgR mean(r)];
    Dsum=[Dsum dr/M];
end
figure(4);
subplot(3,1,1)
plot(1:L,MaxR)
title('�ő��V');
subplot(3,1,2)
plot(1:L,AvgR)
ylim([-1.5 0])
title('���ϕ�V');
subplot(3,1,3)
plot(1:L,Dsum)
title('������V');
end

