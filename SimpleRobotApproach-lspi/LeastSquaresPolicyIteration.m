function theta = LeastSquaresPolicyIteration(L, M, T, B,center) % L:政策反復 M:エピソード T:ステップ B:ガウス関数の個数

right = [0.1 0];
left = [-0.1 0];
foward = [0 0.1];
actions = [right; left; foward];          % 行動の候補
nactions = 3;                             % 行動の数
ganmma = 0.95;                            % 割引率 0.8
epsilon = 0.2;                            % ε-greedyの変数 0.2 小さくなると
sigma = 1;                              % ガウス関数の幅 0.5

%ゴール地点
goal_pos_x = 0.6;
goal_pos_y = 1.0;

goal_pos = [goal_pos_x goal_pos_y];

% デザイン行列X ベクトルrの初期化
X = zeros(M*T, B*nactions);
r = zeros(M*T, 1);


% ガウス関数の中心行列　36ｘ3

%{
    t=[0.6];
    y=[0 1.0];
    center = [];
    for k=1:length(t)
        for j=1:length(y)
            c = [t(k), y(j)];
            center = [center;c];
        end
    end
%}


% モデルパラメータの初期化
theta = zeros(B*nactions, 1);

MaxR=[];
AvgR=[];
Dsum=[];

% 政策反復
for l=1:L
    dr = 0;
    
    % 標本
    for m=1:M
        
        %ゴール地点の変更
        goal_pos_x = round(rand(), 1);
        goal_pos_y = round(rand(), 1);
        goal_pos = [goal_pos_x goal_pos_y];
        
        % 一回目のエピソードの初期値
        robot_pos = [];
        first_robot_pos = [0.6; 0];
        robot_pos = first_robot_pos;
        first_l_action = 4;
        f_state = getRobotState(goal_pos, first_robot_pos, first_l_action);

        %disp([l m]);
        for t=1:T
            state = f_state;
            
            % 状態(位置 速度 行動)の観測
            dist = sum((center - repmat(state',B,1)).^2,2);
            %test = repmat(state',B,1);
            
            %==========================================
            % 距離
            phis = exp(-dist/2/(sigma.^2));
            
            % 現在の状態に関する基底関数
            Q = phis'*reshape(theta, B, nactions);
            %==========================================
            
            % 政策
            policy = zeros(nactions,1);
            
            % εgreedy
            [v, a] = max(Q);
            %{
                if(not(rem(m,5)))
                    epsilon = 1.0;
                    policy = ones(nactions, 1)*epsilon/nactions;
                else
                    policy = ones(nactions, 1)*epsilon/nactions;
                end
            %}
            policy = ones(nactions, 1)*epsilon/nactions;
            policy(a) = 1-epsilon+epsilon / nactions;
            
            %行動選択
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
                %disp(strcat('PLOT : RobotPos(', num2str(robot_pos(1)) , ',' ,num2str(robot_pos(2)), ')'));
            end
            
            %行動の実行
            robot_pos = stepSimulation(robot_pos,l_action);
            f_state = getRobotState(goal_pos, robot_pos, l_action);
            %disp(state);
            
            %if and( state(1) == 0.6,state(2) >= 1.0)
            %   disp('*****************************************');
            %end
            
            %---------------------------------------
            if t>1
                aphi = zeros(B*nactions, 1);
                for a=1:nactions
                    aphi = aphi + getPhi(state, a, center, B, sigma, nactions)*policy(a);
                end
                pphi = getPhi(pstate, paction, center, B, sigma, nactions);
                
                %(M*T)*Bデザイン行列Ｘ, M*T次元ベクトルr
                X( T*(m-1)+t-1, :) = (pphi - ganmma * aphi)';
                r( T*(m-1)+t-1 ) = getReward(goal_pos, robot_pos);
                
                if m==M
                    disp(strcat('Step=',num2str(t),', RobotPos(x,y):(',num2str(robot_pos(1)),', ',num2str(robot_pos(2)),')',', GoalPos(x,y):(',num2str(goal_pos_x),', ',num2str(goal_pos_y),'),', ' Reward=',num2str(r( T*(m-1)+t-1 ))));
                    figure(6);
                    hold on;
                    bar(t,r( T*(m-1)+t-1 ));
                    xlim([0 T]);
                    ylim([0 1]);
                    pause(0.1);
                    if t==T
                        clf(figure(6));
                    end
                end
                dr = dr + r(T*(m-1) + t-1) *ganmma ^(t-1);
            end
            paction = l_action;
            pstate = state;
            if and(t==T,m==M)
                disp('*************EPISODE*************');
            end
        end
        
    end
    
    %政策評価
    theta = pinv(X'*X)*X'*r;
    %theta2 = (X'*X+eye(12)*0.001)\(X'*r);
    %disp(theta);
    %disp(theta2);
    %result = sprintf('%d)Max=%.2f Arg=%.2f Dsum=%.2f\n',l, max(r), mean(r), dr/M);
    %disp([num2str(l) +')Max='+num2str(max(r)) 'Avg='+num2str(mean(r)) 'Dsum='+num2str(dr/M)]);
    %disp([l max(r) mean(r) dr/M]);
    MaxR=[MaxR max(r)];
    AvgR=[AvgR mean(r)];
    Dsum=[Dsum dr/M];
end
figure(2);
subplot(3,1,1)
plot(1:L,MaxR)
title('最大報酬');
subplot(3,1,2)
plot(1:L,AvgR)
ylim([0 0.8])
title('平均報酬');
subplot(3,1,3)
plot(1:L,Dsum)
title('割引報酬');
end

