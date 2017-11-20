function theta = LeastSquaresPolicyIteration(L, M, T, B,center) % L:政策反復 M:エピソード T:ステップ B:ガウス関数の個数

left = [0.1*1/2, 0.1*sqrt(3)/2, -30];
foward = [0, 0.1*1, 0];
right = [0.1*1/2, 0.1*sqrt(3)/2, 30];
actions = deg2rad([-30, 0, 30, 5, -5]);          % 行動の候補
nactions = length(actions);                             % 行動の数
ganmma = 0.95;                            % 割引率 0.8
epsilon = 0.1;                          % ε-greedyの変数 0.2 小さくなると
sigma = 1;                              % ガウス関数の幅 0.5

%ゴール
goal_pos_x = 0.0;
goal_pos_y = 1.0;
goal_area = 0.15;
goal_direction = deg2rad(35);
goal_pos = [goal_pos_x goal_pos_y];
goal = [goal_pos goal_direction];

% デザイン行列X ベクトルrの初期化
X = []; %M*T,3*B

best_theta = zeros(B*nactions, 1);
pmean_r = -2;
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
        %min_x = -0.5;
        %max_x = 0.5;
        %min_y = 0;
        %max_y = 0.8;
        
        %robot_pos_x = round((max_x-min_x).*rand()+min_x, 1);
        %robot_pos_y =  round((max_y-min_y).*rand()+min_y, 1);
        robot_pos_x = 0;
        robot_pos_y = 0;
        robot_pos = [robot_pos_x, robot_pos_y];
        robot_theta = deg2rad(90);
        robot = [robot_pos, robot_theta];                                  %ロボットに関するグローバル座標の値
        
        % 一回目のエピソードの初期値
        %f_state = getRobotState(goal_pos, robot);
        f_state = GlobalPos2LocalPos(goal,robot);
        
        
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
            elseif(ran < policy(1) + policy(2) + policy(3))
                l_action = 3;
            elseif(ran < policy(1) + policy(2) + policy(3) + policy(4))
                l_action = 4;
            else
                l_action = 5;
            end
                        
            %行動の実行
            robot = stepSimulation(robot, actions(l_action), l_action);
            %f_state = getRobotState(goal_pos, robot);
            f_state = GlobalPos2LocalPos(goal,robot);
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
                r = [r,getReward(state, robot, goal)]; 
                if abs(getReward(state, robot, goal)) < goal_area && (robot(3) == goal(3))
                    %disp('!!!!!!!!!!!!!!!!!!!!!!!!!!');
                    %disp('!!!!!!!!!!!GOAL!!!!!!!!!!!');
                    %disp('!!!!!!!!!!!!!!!!!!!!!!!!!!');
                    break;
                end
            end
            paction = l_action;
            pstate = state;
            
            if m==M
                disp(strcat('Step=' ,num2str(t) ,'/NextAction:' ,num2str(rad2deg(actions(l_action))) ,'/RobotPos(x,y):(' ,num2str(robot(1)),', ',num2str(robot(2)),')' ,'/GoalPos(x,y):(' ,num2str(goal_pos_x) ,', ' ,num2str(goal_pos_y) ,'),'  ,'/State(x,y):(',num2str(state(1)) ,', ' ,num2str(state(2)),')', '/Reward=',num2str(r(length(r)))));
            end
            
            if and(t==T,m==M)
                disp('*************EPISODE*************');
            end
            
            % 状態の描画
            plot_f = and(m==M,1);
            if plot_f
                plotSimulation(robot, goal, goal_area, strcat('Policy=',num2str(l),' Episode=',num2str(m)));
                %dplotSimulation(robot, state, goal_area, strcat('Policy=',num2str(l),' Episode=',num2str(m)));
                figure(2);
                if t==1
                    clf;
                else
                    hold on;
                    bar(t,r(length(r)));
                    text(t,r(length(r))-0.01,strcat(num2str(rad2deg(robot(3))),'°'));
                    xlim([0 T]);
                    pause(1);
                end
            end

        end
    end
    
    %政策評価
    theta = pinv(X'*X)*X'*r';
    MaxR=[MaxR max(r)];
    AvgR=[AvgR mean(r)];
    Dsum=[Dsum dr/M];
    
    % 平均報酬が一番高かったthetaを保存しておく
    if mean(r) > pmean_r
        best_theta = theta;
    end
    pmean_r = mean(r);
    
    if l==L 
        theta = best_theta;
    end
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

