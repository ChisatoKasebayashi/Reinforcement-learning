function [phi]=getPhi(state, aind, center, B, sigma, nactions)
    dist = sum((center - repmat(state',B,1)).^2,2);
    phi = zeros(B*nactions,1);
    phi(B*(aind - 1) + 1:B*aind) = exp(-dist/2/sigma^2);
end