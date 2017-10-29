function [reward] = getReward(state, goal_position)
    
    dist = sqrt(sum(state.^2));
    if dist < 0.2
        reward = -dist;
    else
        reward = -1;
    end

%reward = (max(0, min(dist,1))-1)^2;

    %fplot(x,(x-1)^2,[0 1]);
    %ylabel('•ñV');
    %xlabel('‹——£');

end