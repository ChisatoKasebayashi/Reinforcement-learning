function [reward] = getReward(state)

    reward = -sum(abs(state));


%reward = (max(0, min(dist,1))-1)^2;

    %fplot(x,(x-1)^2,[0 1]);
    %ylabel('•ñV');
    %xlabel('‹——£');

end