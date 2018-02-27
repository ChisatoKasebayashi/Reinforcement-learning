function [sigma, mu] = NaturalActorCritic(L, M, T, N, gamma, alpha)
MaxAng = deg2rad(90);
MinAng = deg2rad(-90);
goal_area = 0.15;
step = 0.1;
mu = rand(N-1, 1)-0.5;
sigma = rand;

Z = zeros(M, N);
q = zeros(M, 1);
w = zeros(N, 1);

MaxR=[];
AvgR=[];
Dsum=[];

for l=1:L
    dr = 0;
    r = [];
    for m=1:M
        Global.Goal.pos = [0, 1];
        %初期位置をランダムに
        a=-0.5;
        b= 0.5;
        Global.Robot.pos = [(b-a).*rand + a, 0];
        Global.Robot.angle = deg2rad(60);
        [Local.Goal.pos.x Local.Goal.pos.y] =GlobalPos2LocalPos(Global.Goal.pos, Global.Robot.pos, Global.Robot.angle);
        f_state = getPolarCoordinates(Local.Goal.pos);
        
        
        for t=1:T
            %状態の初期化
            state = f_state;
            
            %行動の選択
            action = randn*sigma + mu'*state;
            action = min(action, MaxAng);
            action = max(action, MinAng);
            
            [Global.Robot.angle Global.Robot.pos] = stepWorldState(Global.Robot.pos,Global.Robot.angle, action, step);
            [Local.Goal.pos.x Local.Goal.pos.y] = GlobalPos2LocalPos(Global.Goal.pos, Global.Robot.pos, Global.Robot.angle);
            state = getPolarCoordinates(Local.Goal.pos);
            
            %記録？！
            states(:,t) = state;
            actions(t) = action;
            dist = sqrt(Local.Goal.pos.x.^2+Local.Goal.pos.y.^2);
            %rewards(m, t) = -abs(dist);
            r = [r,-abs(dist)];
            %dr = dr + gamma^(t-1)*rewards(m,t);
            dr = dr + gamma^(t-1)*r(length(r));
            if( and(m==M,1) )
                plotSimulation(Global.Goal.pos, Global.Robot.pos,Global.Robot.angle, goal_area, strcat('Policy=',num2str(l),' Episode=',num2str(m)));
                %fprintf('Global.Robot(%d,%d)/Local.Goal(%d,%d)\n',Global.Robot.pos(1),Global.Robot.pos(2),Local.Goal.pos.x,Local.Goal.pos.y);
                if t>1
                    figure(2);
                    hold on;
                    bar(t,r(length(r)));
                    text(t-0.5 ,r(length(r))-0.1 ,strcat(num2str(round(rad2deg(state)))));
                    xlim([0 T]);
                else
                    figure(2);
                    clf;
                end
            end
            if abs(dist) < goal_area
                fprintf('GOOOOOOOOOOOOOOOOOOOOAL\n');
                break;
            end
        end
        
        for t=1:T
            %muに関する勾配の計算
            der(1: N-1) = (actions(t) - mu'*states(:, t))*states(:, t)/(sigma^2);
            
%                        der(m, 1:N-1) = der(m, 1:N-1) + ((action - mu'*state)*state/(sigma.^2))';

            %sigamに関する勾配の計算
            der(N) = ((actions(t)-mu'*states(:,t))^2-sigma^2)/(sigma^3);
            %デザイン行列Z及び報酬ベクトルq
            Z(m, :) = Z(m, :) + gamma^(t-1)*der;
            q(m) = q(m) + gamma^(t-1)*(r(length(r)));
        end
    end
    % r - V(s1)
    q = q- dr/M;
    
    %最小二乗法を用いてアドバンテージ関数のモデルパラメータを推定
    Z(:, N) = ones(M, 1);
    w = pinv(Z'*Z)*Z'*q;
    
    %wを用いてモデルパラメータを更新
    mu = mu + alpha*w(1:N-1);
    sigma = sigma + alpha*w(N);
    fprintf('mu:%f/sigma:%f\n',mu,sigma);
    %disp(strcat('Episode:',num2str(l),' /Max:',num2str(max(max(r))), ' /Min:', num2str(min(min(r))), ' /Mean:', num2str(mean(mean(r)))));
    MaxR=[MaxR max(max(r))];
    AvgR=[AvgR mean(mean(r))];
    Dsum=[Dsum dr/M];
end
    
    figure(4);
    subplot(3,1,1)
    plot(1:L,MaxR)
    title('max reward');
    subplot(3,1,2)
    plot(1:L,AvgR)
    title('average');
    subplot(3,1,3)
    plot(1:L,Dsum)
    title('discount sum');
end