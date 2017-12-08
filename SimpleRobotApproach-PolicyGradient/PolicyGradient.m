function [sigma, mu] = PolicyGradient(L, M, T, N, gamma, alpha)
World.Agent.pos = [0, 0];
MaxAng = pi/6;
MinAng = -(pi/6);

mu = rand(N-1, 1);
sigma = rand;

MaxR=[];
AvgR=[];
Dsum=[];


figure(1);clf;

figure(2);clf;
%movegui(figure(2),'center')
figure(3);clf;
%movegui(figure(3),'east')
figure(4);clf;

for l=1:L
    dr = 0;
    for m=1:M
        drs(m) = 0;
        der(m, :) = zeros(1,N);
        World.Goal.pos = [0, 0.8];
        World.Agent.angle = deg2rad(360*rand);
        for t=1:T
            state = zeros(N-1,1);
            state = getRobotState(atan2(World.Goal.pos(2),World.Goal.pos(1)),World.Agent.angle);
            action = randn*sigma + mu'*state;
            action = min(action, MaxAng);
            action = max(action, MinAng);
            World.Agent.angle = setWorldState(World.Agent.angle, action);
            der(m, 1:N-1) = der(m, 1:N-1) + ((action - mu'*state)*state/(sigma.^2))';
            der(m, N) = der(m, N) + ((action-mu'*state).^2-sigma.^2)/(sigma.^3);
            rewards(m, t) = getReward(state);
            drs(m) = drs(m) + gamma^(t-1)*rewards(m, t);
            dr = dr + gamma^(t-1)*rewards(m, t);
            if( and(m==M,1) )
                disp(World);
                plotSimulation(World.Goal.pos, World.Agent.pos,World.Agent.angle , strcat('Policy=',num2str(l),' Episode=',num2str(m)));
                if t>1
                    figure(2);
                    hold on;
                    bar(t,rewards(m, t));
                    text(t-0.5 ,rewards(m, t)-0.1 ,strcat(num2str(round(rad2deg(state)))));
                    xlim([0 T]);
                else
                    figure(2);
                    clf;
                end
            end
            if( and(m==M,1) )
                figure(3);
                clf;
                hold on;
                x = linspace(-pi/2, pi/2);
                plot([action,action],[0,1],'r');
                plot(x,gaussianFunction(mu,sigma,x));
                xlim([-pi/2 pi/2]);
                ylim([0 1]);
                pause(0.01);
            end
        end
    end
    b = drs * diag(der*der') / trace(der*der');
    derJ = 1/M * ((drs-b) * der)';
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
title('max reward');
subplot(3,1,2)
plot(1:L,AvgR)
title('average');
subplot(3,1,3)
plot(1:L,Dsum)
title('discount sum');
end