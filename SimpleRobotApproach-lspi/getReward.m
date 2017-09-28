function [reward] = getReward(goal_position, current_position)
    dist = sqrt((goal_position(1)-current_position(1)).^2 + (goal_position(2)-current_position(2)).^2);
    reward = (max(0, min(dist,1))-1)^2;
    
    %fplot(x,(x-1)^2,[0 1]);
    %ylabel('��V');
    %xlabel('����');

end