function main
clear all;

t = [0 1];
y = [0 1.0];
%t=[0.3, 0.5, 0.7, 0.9];
%y=[0.3, 0.5, 0.7, 0.9, 1.1];
center = [];
for k=1:length(t)
    for j=1:length(y)
        c = [t(k), y(j)];
        center = [center;c];
    end
end

L = 15;
M = 100;
T = 15;
B=length(center);
gamma=0.95;
nactions=3;
sigma = 1;

theta=LeastSquaresPolicyIteration(L,M,T,B,center);

figure(3);
syms sx sdx;
subplot(1,3,1)
f1 = ValueFunction(sx,sdx,theta,B,center,sigma,nactions,1);
fsurf(f1,[0 1.2 0 1.2]);
xlabel('x')
ylabel('y')
zlim([-30 30])
title('right')
subplot(1,3,2)
f2 = ValueFunction(sx,sdx,theta,B,center,sigma,nactions,2);
fsurf(f2,[0 1.2 0 1.2]);
xlabel('x')
ylabel('y')
zlim([-30 30])
title('left')
subplot(1,3,3)
f3 = ValueFunction(sx,sdx,theta,B,center,sigma,nactions,3);
fsurf(f3,[0 1.2 0 1.2]);
xlabel('x')
ylabel('y')
zlim([-30 30])
title('forward')
end