function [groups] = my_kmeans(im, k, method, useXY)

%X should be 5 x N where N is the number of pixels in the original image
%mu0/mu is a 5 x k matrix of cluster means

X = ConvertColourScheme(im);
[nRows, nCols] = size(im(:,:,1));

if ~useXY
    X = X(1:3,:); 
end


%% STEP 1: Set initial labels for all points

if strcmp(method,'kmpp')
    groups = kmpp(X, k);
elseif strcmp(method,'random')
    groups = RndInit(X, k);
else
    error('Unknown method specified!');
end

n = numel(groups);
prevGroups = zeros(1,n);

while any(groups ~= prevGroups)
    
    %% STEP 2: Remove Empty Clusters
    [~,~,prevGroups(:)] = unique(groups);      
    
    %% Step 3: Compute cluster centres and assign labels
    mu = X * normalize(sparse(1:n, prevGroups, 1), 1); 
    [~, groups] = min(1/2 * dot(mu,mu,1)' - mu'*X ,[] , 1);
end

%% Step 4: When no labels have been changed, return the list of labels 
groups = reshape(groups, [nCols, nRows])';

end

function Y = normalize(X, dim)
if nargin == 1
    % Determine which dimension sum will use
    dim = find(size(X)~=1,1);
    if isempty(dim), dim = 1; end
end
Y = X./sum(X,dim);
end
