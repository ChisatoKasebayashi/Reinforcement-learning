function plotMountainCar(x)
    figure(1)
    clf
    hold on
    
    mapX = -5:pi/100:5;
    mapY = sin(3*mapX);
    
    xlim([-1.1 0.5]);
    t = title('MountainCar');
    set(t,'FontSize',16);
    
    %Mountain‚Ì•`ŽÊ
    plot(mapX,mapY);
    
    %Car‚Ì•`ŽÊ
    plot(x,sin(3*x),'or','LineWidth',4);
    if x == 0.5
        disp('**************!!!!GOAL!!!!******************');
    end
    
    pause(0.01);
end