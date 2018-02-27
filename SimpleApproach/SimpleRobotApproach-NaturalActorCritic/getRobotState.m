function state = getRobotState(goalang,robotang)
state = goalang - robotang;
%fprintf('state:%f\n',state);
while state > pi
    state = state - 2*pi;
end
while state < (-pi)
    state = state + 2*pi;
end

end