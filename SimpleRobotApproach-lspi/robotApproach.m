function robotApproach(T,B,theta,test_epsilon,center)
robot_pos = [0, 0];
robot_theta = deg2rad(90);
robot = [robot_pos, robot_theta];

actions = deg2rad([-30, 0, 30, 5, -5]);          % 行動の候補
nactions = length(actions);                             % 行動の数
ganmma = 0.95;                            % 割引率 0.8
sigma = 1;

goal_area = 0.15;
goal_direction = deg2rad(35);
goal_pos = [0 1];
goal = [goal_pos goal_direction];

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
    policy = ones(nactions, 1)*test_epsilon/nactions;
    policy(a) = 1-test_epsilon+test_epsilon / nactions;
    
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
    
    % プロット
    plotSimulation(robot, goal, goal_area, strcat('TEST PHESE'));
    
    %行動の実行
    robot = stepSimulation(robot, actions(l_action), l_action);
    f_state = GlobalPos2LocalPos(goal,robot);

end

end