function [sigma, mu] = PolicyGradient(L, M, T, N, gamma, alpha)
MaxAng = pi/6;
MinAng = -(pi/6);
goal_area = 0.15;

step = 0.1;

mu = rand(N-1, 1);
sigma = rand;

MaxR=[];
AvgR=[];
Dsum=[];

figure(1);clf;
movegui(figure(2),'west')
figure(2);clf;
movegui(figure(2),'center')
%figure(3);clf;
%movegui(figure(3),'east')
figure(4);clf;

for l=1:L
    dr = 0;
    r = [];
    for m=1:M
        drs(m) = 0;
        der(m, :) = zeros(1,N);
        Global.Goal.pos = [0, 1];
        %‰ŠúˆÊ’u‚ðƒ‰ƒ“ƒ_ƒ€‚É
        a=-0.5;
        b= 0.5;
        Global.Robot.pos = [(b-a).*rand + a, 0];
        Global.Robot.angle = deg2rad(60);
        [Local.Goal.pos.x Local.Goal.pos.y] =GlobalPos2LocalPos(Global.Goal.pos, Global.Robot.pos, Global.Robot.angle);
        f_state = getPolarCoordinates(Local.Goal.pos);
        t_rewards = [];
        for t=1:T
            state = f_state;
            
            action = randn*sigma + mu'*state;
            action = min(action, MaxAng);
            action = max(action, MinAng);
            %fprintf('action:%f\n', action);
            %disp(strcat('robot:',num2str(Global.Robot.pos(1)),',',num2str(Global.Robot.pos(2)),'/angle:',num2str(Global.Robot.angle)));
            [Global.Robot.angle Global.Robot.pos] = stepWorldState(Global.Robot.pos,Global.Robot.angle, action, step);
            % s“®‚Ì§ŒÀ
            if Global.Robot.pos(1)>0.5
                Global.Robot.pos(1) = 0.5;
            elseif Global.Robot.pos(1)<-0.5
                Global.Robot.pos(1) = -0.5;
            end
            if Global.Robot.pos(2)>1.2
                Global.Robot.pos(2) = 1.2;
            elseif Global.Robot.pos(2)<0
                Global.Robot.pos(2) = 0;
            end
            
            [Local.Goal.pos.x Local.Goal.pos.y] = GlobalPos2LocalPos(Global.Goal.pos, Global.Robot.pos, Global.Robot.angle);
            state = getPolarCoordinates(Local.Goal.pos);
            %disp(strcat('----------','robot:',num2str(Global.Robot.pos),'/angle:',num2str(Global.Robot.angle)));
            der(m, 1:N-1) = der(m, 1:N-1) + ((action - mu'*state)*state/(sigma.^2))';
            der(m, N) = der(m, N) + ((action-mu'*state).^2-sigma.^2)/(sigma.^3);
            %r = [r, getReward(state)];
            r = [r,-abs(sqrt(Local.Goal.pos.x.^2+Local.Goal.pos.y.^2))];
            t_rewards = [t_rewards, abs(sqrt(Global.Goal.pos(1)-(Global.Robot.pos(1)).^2 + (Global.Goal.pos(2)-Global.Robot.pos(2)).^2))];
            drs(m) = drs(m) + gamma^(t-1)*r(length(r));
            dr = dr + gamma^(t-1)*r(length(r));
            
            if( and(m==M,1) )
                plotSimulation(Global.Goal.pos, Global.Robot.pos,Global.Robot.angle, goal_area, strcat('Policy=',num2str(l),' Episode=',num2str(m)));
                fprintf('Global.Robot(%d,%d)/Local.Goal(%d,%d)\n',Global.Robot.pos(1),Global.Robot.pos(2),Local.Goal.pos.x,Local.Goal.pos.y);
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
            
            if abs(sqrt(Local.Goal.pos.x.^2+Local.Goal.pos.y.^2)) < goal_area
                fprintf('GOOOOOOOOOOOOOOOOOOOOAL\n');
                break;
            end
            
        end
    end
    b = drs * diag(der*der') / trace(der*der');
    derJ = 1/M * ((drs-b) * der)';
    mu = mu + alpha *derJ(1:N-1);
    sigma = sigma + alpha * derJ(N);
    %{
    if sigma < 0.3
        sigma =0.3;
    end
    if 3 < sigma
        sigma =3;
    end
    %}
    %fprintf('step:%d/sigma:%f/mu%f,%f\n',l,sigma,mu(1),mu(2));
    %disp(strcat('Episode:',num2str(l),' /Max:',num2str(max(max(rewards))), ' /Min:', num2str(min(min(rewards))), ' /Mean:', num2str(mean(mean(rewards)))));
    MaxR=[MaxR max(max(t_rewards))];
    AvgR=[AvgR mean(mean(t_rewards))];
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