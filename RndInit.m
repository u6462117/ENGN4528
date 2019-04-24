function [label] = RndInit(X, k)

dataLen = size(X,1);
mu = rand(dataLen,k);

[~,label] = min(dot(mu,mu,1)'/2-mu'*X,[],1); 
end