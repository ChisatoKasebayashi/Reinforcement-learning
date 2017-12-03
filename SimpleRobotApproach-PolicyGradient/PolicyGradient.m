function [sigma, mu] = PolicyGradient(L, M, T, N, gamma, alpha)
robotpos = [0, 0];                                             %シミュレータの初期値
MaxAng = deg2rad(180);
MinAng = deg2rad(0);


mu = rand(N-1, 1)-0.5;
sigma = rand*10;

MaxR=[];
AvgR=[];
Dsum=[];

%政策反復
for l=1:L
    dr = 0;
    rand();
    
    %標本
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
            
            %状態の初期化
            state = zeros(N-1,1);
            
            %ロボットの状態観測
            state = getRobotState(goalpos, robotpos, robotang);
            
            %行動の選択
            action = randn*sigma + mu'*state;
            action = min(action, MaxAng);
            action = max(action, MinAng);
            
            robotang = stepSimulation(state, action);
            state = getRobotState(goalpos, robotpos, robotang);
            
            %平均muに関する勾配の計算
            der(m, 1:N-1) = der(m, 1:N-1) + ((action - mu'*state)*state/(sigma.^2))';
            
            %標準偏差sigmaに関する勾配の計算
            der(m, N) = der(m, N) + ((action-mu'*state).^2-sigma.^2)/(sigma.^3);
            
            %割引き報酬和の計算
            rewards(m, t) = getReward(state);
            drs(m) = drs(m) + gamma^(t-1)*rewards(m, t);
            dr = dr + gamma^(t-1)*rewards(m, t);
            %行動の実行
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
    
    %最小分散ベースラインを計算
    b = drs * diag(der*der') / trace(der*der');
    
    %勾配を推定
    derJ = 1/M * ((drs-b) * der)';
    
    %モデルパラメータを更新
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
title('最大報酬');
subplot(3,1,2)
plot(1:L,AvgR)
ylim([-1.8 -1])
title('平均報酬');
subplot(3,1,3)
plot(1:L,Dsum)
title('割引報酬');
end