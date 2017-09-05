clear all;

L = 10;
M = 200;
T = 200;
B=12;
gamma=0.7;
nactions=3;
theta=LeastSquaresPolicyIteration(L,M,T,B);

% ガウス関数の中心行列　36ｘ3
t=[-1.2, -0.35,0.5];
y=[-1.5, -0.5, 0.5, 1.5];
center = [];
for k=1:3
    for j=1:4
        c = [t(k), y(j)];
        center = [center;c];
    end
end

figure(3);
syms sx sdx;
subplot(1,3,1)
f1 = ValueFunction(sx,sdx,theta,B,center,gamma,nactions,1);
fsurf(f1,[-1.2 0.5 -1.5 1.5]);
subplot(1,3,2)
f2 = ValueFunction(sx,sdx,theta,B,center,gamma,nactions,2);
fsurf(f2,[-1.2 0.5 -1.5 1.5]);
subplot(1,3,3)
f3 = ValueFunction(sx,sdx,theta,B,center,gamma,nactions,3);
fsurf(f3,[-1.2 0.5 -1.5 1.5]);
