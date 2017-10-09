function main
clear all;

%t = [0.2 0.8];
%y = [0.3];

%t = [0.3 0.6 0.9];
%y = [0.3 0.8];

t = [-0.4 -0.2 0 0.2 0.2];
y = [ 0.3];

center = [];
for k=1:length(t)
    for j=1:length(y)
        c = [t(k), y(j)];
        center = [center;c];
    end
end

L = 10;
M = 300;
T = 30;
B=length(center);
gamma=0.95;
nactions=3;
sigma = 0.5;

theta=LeastSquaresPolicyIteration(L,M,T,B,center);

figure(3);
syms sx sdx;
subplot(1,3,1)
f1 = ValueFunction(sx,sdx,theta,B,center,sigma,nactions,1);
fsurf(f1,[-0.6 0.4 0 1]);
xlabel('x')
ylabel('y')
zlim([-10 50])
title('right')
subplot(1,3,2)
f2 = ValueFunction(sx,sdx,theta,B,center,sigma,nactions,2);
fsurf(f2,[-0.6 0.4 0 1]);
xlabel('x')
ylabel('y')
zlim([-10 50])
title('left')
subplot(1,3,3)
f3 = ValueFunction(sx,sdx,theta,B,center,sigma,nactions,3);
fsurf(f3,[-0.6 0.4 0 1]);
xlabel('x')
ylabel('y')
zlim([-10 50])
title('forward')
end