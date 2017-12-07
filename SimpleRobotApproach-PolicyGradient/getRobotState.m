function state = getRobotState(goalang,robotang)
state = goalang - robotang;
while state > pi
    state = state - 2*pi;
end
while state < (-pi)
    state = state + 2*pi;
end

end