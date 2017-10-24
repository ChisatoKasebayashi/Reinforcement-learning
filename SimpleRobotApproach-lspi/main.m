function main

clear figure(1);
clear figure(2);
clear figure(3);

%t = [-0.4 0 0.4];
%y = [-0.4 0 0.4];

t = [-0.5 -0.2 0 0.2 0.5];
y = [-0.5 -0.2 0 0.2 0.5];

center = [];
for k=1:length(t)
    for j=1:length(y)
        c = [t(k), y(j)];
        center = [center;c];
    end
end

L = 10;
M = 200;
T = 15;
B=length(center);
gamma=0.95;
nactions=3;
sigma = 0.5;

theta=LeastSquaresPolicyIteration(L,M,T,B,center);

figure(3);
syms sx sdx;
subplot(1,3,1)
f1 = ValueFunction(sx,sdx,theta,B,center,sigma,nactions,1);
fsurf(f1,[-0.6 0.6 0 1]);
xlabel('x')
ylabel('y')
zlim([-50 30])
title('right')
subplot(1,3,2)
f2 = ValueFunction(sx,sdx,theta,B,center,sigma,nactions,2);
fsurf(f2,[-0.6 0.6 0 1]);
xlabel('x')
ylabel('y')
zlim([-50 30])
title('left')
subplot(1,3,3)
f3 = ValueFunction(sx,sdx,theta,B,center,sigma,nactions,3);
fsurf(f3,[-0.6 0.6 0 1]);
xlabel('x')
ylabel('y')
zlim([-50 30])
title('forward')
end