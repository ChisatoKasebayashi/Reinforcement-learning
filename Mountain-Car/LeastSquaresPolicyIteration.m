function theta = LeastSquaresPolicyIteration(L, M, T, B) % L:政策反復 M:エピソード T:ステップ B:ガウス関数の個数

%{
    actions = [-0.2, 0, 0.2];          % 行動の候補
    nactions = 3;                      % 行動の数
    ganmma = 0.95;                     % 割引率
    epsilon = 0.2;                     % ε-greedyの変数
    sigma = 0.5;                       % ガウス関数の幅
    
    % デザイン行列X ベクトルrの初期化
    X = zeros(M*T, B*nactions);
    r = zeros(M*T, 1);
    
    % 一回目のエピソードの初期値
    f_state = [-0.5; 0; 0];
    
    % ガウス関数の中心行列　36ｘ3
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
    
    % モデルパラメータの初期化
    theta = zeros(B*nactions, 1);
   
    % 政策反復
    for l=1:L
        dr = 0;
        rand('state',1);
        
        % 標本
        for m=1:M
            disp('*************EPISODE*************');
            state = f_state;
            
            for t=1:T+1
                % 状態(位置 速度 行動)の観測
                dist = sum((center - repmat(state',B,1)).^2,2);            % dist:36x1
                %test = repmat(state',B,1);
                
                %==========================================
                % 距離 
                phis = exp(-dist/2/(ganmma.^2));                           % phis:36x1
                
                % 現在の状態に関する基底関数
                Q = phis'*reshape(theta, B, nactions);                     % Q:1x3
                %==========================================
                
                % 政策
                policy = zeros(nactions,1);
                
                % εgreedy
                [v, a] = max(Q);                                           % [maxnum index] = max(Q)
                policy = ones(nactions, 1)*epsilon/nactions;
                policy(a) = 1-epsilon+epsilon / nactions;
                
            %行動選択
            ran = rand;
            if(ran < policy(1))
                action = 1;
            elseif(ran < policy(1) + policy(2))
                action = 2;
            else
                action = 3;
            end
            u(2) = actions(action);
            
            %行動の実行
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
                
                %(M*T)*Bデザイン行列Ｘ, M*T次元ベクトルr
                X( T*(m-1)+t-1, :) = (pphi - ganmma * aphi)';
                r( T*(m-1)+t-1 ) = 1 / 1 + (0.5 - state(1).^2);
                dr = dr + r(T*(m-1) + t-1) *ganmma ^(t-1);
            end
            paction = action;
            pstate = state;
        end
    end
    
    %政策評価
    theta = pinv(X'*X)*X'*r;
    
    %result = sprintf('%d)Max=%.2f Arg=%.2f Dsum=%.2f\n',l, max(r), mean(r), dr/M);
    %disp([num2str(l) +')Max='+num2str(max(r)) 'Avg='+num2str(mean(r)) 'Dsum='+num2str(dr/M)]);
    disp([l max(r) mean(r) dr/M]);
    end
%}    

    actions = [-0.2, 0, 0.2];          % 行動の候補
    nactions = 3;                      % 行動の数
    ganmma = 0.90;                     % 割引率 0.8
    epsilon = 0.2;                     % ε-greedyの変数 0.2 小さくなると
    sigma = 0.8;                       % ガウス関数の幅 0.5
    
    % デザイン行列X ベクトルrの初期化
    X = zeros(M*T, B*nactions);
    r = zeros(M*T, 1);
    
    % 一回目のエピソードの初期値
    f_state = [-0.5; 0];
    
    % ガウス関数の中心行列　36ｘ3
    t=[-1.2, -0.35,0.5];
    y=[-1.5, -0.5, 0.5, 1.5];
    center = [];
    for k=1:3
        for j=1:4
            c = [t(k), y(j)];
            center = [center;c];
        end
    end
    
    % モデルパラメータの初期化
    theta = zeros(B*nactions, 1);
   
    MaxR=[];
    AvgR=[];
    Dsum=[];
    
    % 政策反復
    for l=1:L
        dr = 0;
        rand('state',1);
        
        % 標本
        for m=1:M
            

            disp('*************EPISODE*************');
            state = f_state;
            disp([l m]);
            for t=1:T+1
                % 状態(位置 速度 行動)の観測
                dist = sum((center - repmat(state',B,1)).^2,2);            % dist:36x1
                %test = repmat(state',B,1);
                
                %==========================================
                % 距離 
                phis = exp(-dist/2/(sigma.^2));                           % phis:36x1
                
                % 現在の状態に関する基底関数
                Q = phis'*reshape(theta, B, nactions);                     % Q:1x3
                %==========================================
                
                % 政策
                policy = zeros(nactions,1);
                
                % εgreedy
                [v, a] = max(Q);                                           % [maxnum index] = max(Q)
                policy = ones(nactions, 1)*epsilon/nactions;
                policy(a) = 1-epsilon+epsilon / nactions;
                
            %行動選択
            ran = rand;
            if(ran < policy(1))
                action = 1;
            elseif(ran < policy(1) + policy(2))
                action = 2;
            else
                action = 3;
            end
            u(2) = actions(action);
            
            %行動の実行
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
                
                %(M*T)*Bデザイン行列Ｘ, M*T次元ベクトルr
                X( T*(m-1)+t-1, :) = (pphi - ganmma * aphi)';
                r( T*(m-1)+t-1 ) = 1 / (1 + (0.5 - state(1)).^2);
                dr = dr + r(T*(m-1) + t-1) *ganmma ^(t-1);
            end
            paction = action;
            pstate = state;
        end
    end
    
    %政策評価
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

