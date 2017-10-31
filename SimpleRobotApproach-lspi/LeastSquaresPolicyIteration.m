function theta = LeastSquaresPolicyIteration(L, M, T, B,center) % L:政策反復 M:エピソード T:ステップ B:ガウス関数の個数

left = [0.1*1/2, 0.1*sqrt(3)/2, -30];
foward = [0, 0.1*1, 0];
right = [0.1*1/2, 0.1*sqrt(3)/2, 30];
actions = [-30, 0, 30];          % 行動の候補
nactions = 3;                             % 行動の数
ganmma = 0.95;                            % 割引率 0.8
t_epsilon = 0.1;                          % ε-greedyの変数 0.2 小さくなると
sigma = 0.5;                              % ガウス関数の幅 0.5

%ゴール地点
goal_pos_x = 0.0;
goal_pos_y = 1.0;

goal_pos = [goal_pos_x goal_pos_y];

% デザイン行列X ベクトルrの初期化
X = []; %M*T,3*B
count = [];


% モデルパラメータの初期化
theta = zeros(B*nactions, 1);

MaxR=[];
AvgR=[];
Dsum=[];

% 政策反復
for l=1:L
    dr = 0;
    r = [];
    X = [];
    x = [];
    % 標本
    for m=1:M
        
        %robotのスタート位置の変更
        min_x = -0.5;
        max_x = 0.5;
        min_y = 0;
        max_y = 1;
        
        robot_pos_x = round((max_x-min_x).*rand()+min_x, 1);
        robot_pos_y =  round((max_y-min_y).*rand()+min_y, 1);
        robot_pos = [robot_pos_x, robot_pos_y];
        robot_theta = 0;
        robot = [robot_pos robot_theta];
        
        % 一回目のエピソードの初期値
        f_state = getRobotState(goal_pos, robot);
        
        % εを徐々に小さくする
        %t_epsilon = epsilon - m*epsilon/M;

        
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
            t_epsilon = 1 - l*0.09;
            policy = ones(nactions, 1)*t_epsilon/nactions;
            policy(a) = 1-t_epsilon+t_epsilon / nactions;
            
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
                plotSimulation(robot ,goal_pos ,strcat('Policy=',num2str(l),' Episode=',num2str(m)));
            end
            
            %行動の実行
            robot = stepSimulation(robot, actions(l_action));
            f_state = getRobotState(goal_pos, robot);
            %---------------------------------------
            if t>1
                aphi = zeros(B*nactions, 1);
                for a=1:nactions
                    aphi = aphi + getPhi(state, a, center, B, sigma, nactions)*policy(a);
                end
                pphi = getPhi(pstate, paction, center, B, sigma, nactions);
                
                %(M*T)*Bデザイン行列Ｘ, M*T次元ベクトルr
                x = [(pphi - ganmma * aphi)'];
                X = [X; x];
                r = [r,getReward(state)]; 
                if abs(getReward(state)) < 0.15
                    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!');
                    disp('!!!!!!!!!!!GOAL!!!!!!!!!!!');
                    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!');
                    break;
                end
                
                if m==M
                    disp(strcat('Step=' ,num2str(t) ,'/RobotPos(x,y):(' ,num2str(robot(1)),', ',num2str(robot(2)),')' ,'/GoalPos(x,y):(' ,num2str(goal_pos_x) ,', ' ,num2str(goal_pos_y) ,'),'  ,'/State(x,y):(',num2str(state(1)) ,', ' ,num2str(state(2)),',' ,num2str(state(3)) ,')', '/Reward=',num2str(r(length(r)))));
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
    
    %政策評価
    theta = pinv(X'*X)*X'*r';
    MaxR=[MaxR max(r)];
    AvgR=[AvgR mean(r)];
    Dsum=[Dsum dr/M];
end
figure(4);
subplot(3,1,1)
plot(1:L,MaxR)
title('最大報酬');
subplot(3,1,2)
plot(1:L,AvgR)
ylim([-1.5 0])
title('平均報酬');
subplot(3,1,3)
plot(1:L,Dsum)
title('割引報酬');
end

