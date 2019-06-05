function [boolSlingshotFound, recs] = detectSlingshot(vidFrame)
% DETECTSLINGSHOT  Look for presence of slingshot in the video frame.
%   [boolSlingshotFound, recs] = DETECTSLINGSHOT(vidFrame) looks for 
%   slingshot in the video frame and returns boolean value indicating 
%   if it is found and the slingshot detected in matrix form
%

%% LAB
% Convert RGB image to chosen color space
I = rgb2lab(vidFrame);

% Define thresholds for channel 1 based on histogram settings
channel1Min = 35.052;
channel1Max = 81.959;

% Define thresholds for channel 2 based on histogram settings
channel2Min = -3.033;
channel2Max = 15.326;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 22.104;
channel3Max = 42.792;

% Create mask based on chosen histogram thresholds
result = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);

%Perform closing on the image
se = strel('diamond',2);
result = imclose(result,se);

%Define cluster thresholds
min_thresh = 160; 
max_thresh = 1500;

%Perform connected component analysis
CC          = bwconncomp(result);
val         = cellfun(@(x) numel(x),CC.PixelIdxList);
slingshotFound  = CC.PixelIdxList(val > min_thresh & val<max_thresh);

recs = cell(1,0);

%Construct the bounding boxes for all pixel clusters which pass the tests
for slingshot = 1:length(slingshotFound)
    pixels = slingshotFound{slingshot};
    [rows, cols] = ind2sub(size(vidFrame), pixels); 

    topRow = min(rows);
    topCol = min(cols);
    pixWid = max(cols) - min(cols);
    pixHgt = max(rows) - min(rows);

    % Remove objects that do not meet the expected aspect ratio of the
    % slingshot
    if 2.4<pixHgt/pixWid && 4>pixHgt/pixWid
        if 15<=pixWid && 500>pixWid
            recs{1,end+1} = [topCol topRow  pixWid pixHgt];
        end
    end
    
end

boolSlingshotFound = 0;

if ~isempty(recs)
    recsCheck = recs{1};
    
    topCol = recsCheck(1);
    topRow = recsCheck(2);
    pixWid = recsCheck(3);
    if (topRow + 20 < 320) && (topCol + pixWid + 135 < 480)
        boolSlingshotFound = 1;
    end
end


end