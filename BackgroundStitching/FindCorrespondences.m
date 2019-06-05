function [MOVINGREG, TBetter] = FindCorrespondences(prevFrame,currFrame)
% FindCorrespondences This function takes the previous and current frame
% and performs feature matching using SURF features to determine the
% translation and scaling which has taken place. This information is
% returned in the movement registration struct, MOVINGREG. A RANSAC
% algorithm is then run on the matched points to disregard outliers and the
% moving and scaling information is stored in the transformation matrix
% TBetter.


% Convert RGB images to grayscale
currFrame = rgb2gray(currFrame);
prevFrame = rgb2gray(prevFrame);

%Remove the score, music button, pause button etc.
currFrame(1:65,1:65) = 0;
currFrame(1:50,320:end) = 0;
currFrame(260:end,422:end) = 0;
prevFrame(1:65,1:65) = 0;
prevFrame(1:50,320:end) = 0;
prevFrame(260:end,422:end) = 0;

% Default spatial referencing objects
fixedRefObj = imref2d(size(currFrame));
movingRefObj = imref2d(size(prevFrame));

% Detect SURF features
fixedPoints = detectSURFFeatures(currFrame,'MetricThreshold',750.000000,'NumOctaves',3,'NumScaleLevels',5);
movingPoints = detectSURFFeatures(prevFrame,'MetricThreshold',750.000000,'NumOctaves',3,'NumScaleLevels',5);

% Extract features
[fixedFeatures,fixedValidPoints] = extractFeatures(currFrame,fixedPoints,'Upright',true);
[movingFeatures,movingValidPoints] = extractFeatures(prevFrame,movingPoints,'Upright',true);

% Match features
indexPairs = matchFeatures(fixedFeatures,movingFeatures,'MatchThreshold',21.944444,'MaxRatio',0.219444);
fixedMatchedPoints = fixedValidPoints(indexPairs(:,1));
movingMatchedPoints = movingValidPoints(indexPairs(:,2));
MOVINGREG.FixedMatchedFeatures = fixedMatchedPoints;
MOVINGREG.MovingMatchedFeatures = movingMatchedPoints;

%Initialise outputs
TBetter = NaN;
MOVINGREG.Transformation = NaN;

% Apply transformation - Results may not be identical between runs because of the randomized nature of the algorithm
try
tform = estimateGeometricTransform(movingMatchedPoints,fixedMatchedPoints,'similarity');
MOVINGREG.Transformation = tform;
MOVINGREG.RegisteredImage = imwarp(prevFrame, movingRefObj, tform, 'OutputView', fixedRefObj, 'SmoothEdges', true);
TBetter = tform.T;

%Find the translation transl - this can only be positive in x, so remove
%negative points
transl = movingMatchedPoints.Location - fixedMatchedPoints.Location;
transl = transl(transl(:,1) > 0,:);

%Perform RANSAC to remove outliers
sampleSize = 2; % number of points to sample per trial
maxDistance = 2; % max allowable distance for inliers
fitLineFcn = @(points) polyfit(points(:,1),points(:,2),1); % fit function using polyfit
evalLineFcn = ...   % distance evaluation function
    @(model, points) sum((points(:, 2) - polyval(model, points(:,1))).^2,2);

[~, inlierIdx] = ransac(transl,fitLineFcn,evalLineFcn, ...
    sampleSize,maxDistance);

%Find the mean translation of the inliers
out = mean(transl(inlierIdx, :), 1);

%Return the translation information
TBetter(3,1) = out(1);
TBetter(3,2) = out(2);
catch
    
    %In case of errors, few matches were found. Assume no translation
    TBetter(3,1) = 0;
    TBetter(3,2) = 0;
end

% Store spatial referencing object
MOVINGREG.SpatialRefObj = fixedRefObj;

end

