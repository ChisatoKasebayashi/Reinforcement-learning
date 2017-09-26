function main
clear all;

L = 30;
M = 100;
T = 12;
B=2;
gamma=0.95;
nactions=3;
sigma = 0.5;
theta=LeastSquaresPolicyIteration(L,M,T,B);

% ガウス関数の中心行列　36ｘ3
%{
t=[-1.2, -0.35,0.5];
y=[-1.5, -0.5, 0.5, 1.5];
center = [];
for k=1:3
    for j=1:4
        c = [t(k), y(j)];
        center = [center;c];
    end
end
%}

    t=[0.6];
    y=[0 1.0];
    center = [];
    for k=1:length(t)
        for j=1:length(y)
            c = [t(k), y(j)];
            center = [center;c];
        end
    end

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