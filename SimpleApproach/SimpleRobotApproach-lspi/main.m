

clear figure(1);
clear figure(2);
clear figure(3);

%t = [-0.4 0 0.4];
%y = [-0.4 0 0.4];

x = [-1 -0.5 0 0.5 1];
y = [-1 -0.5 0 0.5 1];

center = [];
for k=1:length(x)
    for j=1:length(y)
        c = [x(k), y(j)];
        center = [center;c];
    end
end

L = 20;
M = 400;
T = 15;
B=length(center);
gamma=0.95;
sigma = 0.5;

% TRAINフェーズ
theta=LeastSquaresPolicyIteration(L,M,T,B,center);

test_epsilon = 0.000001;
% TESTフェーズ
robotApproach(T,B,theta,test_epsilon,center);