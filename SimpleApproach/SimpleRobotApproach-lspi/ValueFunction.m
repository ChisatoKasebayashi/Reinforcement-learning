function Q = ValueFunction(x,y,the,theta,B,center,gamma,nactions,index)
state = [x;y;the];
dist = sum((center - repmat(state',B,1)).^2,2);            % dist:36x1
phis = exp(-dist/2/(gamma.^2));                           % phis:36x1
q = phis'*reshape(theta, B, nactions);                     % Q:1x3
Q = q(index);
end