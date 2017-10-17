function [reward] = getReward(goal_position, current_position)

%if or(or(current_position(1)>1.2, 0>current_position(1)), or(current_position(2)>1, 0>current_position(2)))
%    reward = -0.2;
%else
    dist = sqrt((goal_position(1)-current_position(1)).^2 + (goal_position(2)-current_position(2)).^2);
    reward = (max(0, min(dist,1))-1)^2;
    %reward = 1 -dist;
    %reward = -0.4*(dist - 1)^3;
%end
    
    %fplot(x,(x-1)^2,[0 1]);
    %ylabel('•ñV');
    %xlabel('‹——£');

end