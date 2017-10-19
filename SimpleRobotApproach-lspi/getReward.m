function [reward] = getReward(goal_position, current_position)

relative_position = goal_position - current_position';
reward = -sum(abs(relative_position));

%reward = (max(0, min(dist,1))-1)^2;

    %fplot(x,(x-1)^2,[0 1]);
    %ylabel('•ñV');
    %xlabel('‹——£');

end