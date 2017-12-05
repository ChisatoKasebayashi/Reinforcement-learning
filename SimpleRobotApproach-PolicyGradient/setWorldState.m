function angle = setWorldState( current_angle, action )
while current_angle > pi
    current_angle = current_angle - pi;
end
while current_angle < (-pi)
    current_angle = current_angle + pi;
end
angle = current_angle + action;
end