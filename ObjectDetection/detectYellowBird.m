function [recs] = detectYellowBird(vidFrame)
% DETECTYELLOWBIRD  Look for any yellow birds in the video frame.
%   [recs] = DETECTYELLOWBIRD(vidFrame) looks for any yellow birds in the
%   video frame and returns all the yellow birds detected in matrix form
%

%% Remove pause and score
% only if it is a full frame, not the watchbox
if size(vidFrame,1) > 300
    vidFrame(1:65,1:65) = 0;
    vidFrame(1:50,320:end) = 0;
    vidFrame(260:end,422:end) = 0;
end

% Convert RGB image to chosen color space
I = rgb2hsv(vidFrame);

% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.136;
channel1Max = 0.199;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.304;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.000;
channel3Max = 1.000;

% Create mask based on chosen histogram thresholds
result = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);

thresh = 190;
upThresh = 400;

se = strel('disk',8);
result = imclose(result,se);

CC          = bwconncomp(result);
val         = cellfun(@(x) numel(x),CC.PixelIdxList);
birdsFound  = CC.PixelIdxList(val > thresh & val < upThresh);

recs = cell(1,0);

for bird = 1:length(birdsFound)
    pixels = birdsFound{bird};
    [rows, cols] = ind2sub(size(vidFrame), pixels);
    
    topRow = min(rows) - 10;
    topCol = min(cols) - 10;
    pixWid = max(cols) - min(cols) + 20;
    pixHgt = max(rows) - min(rows) + 20;
    
    if 0.7 < pixHgt/pixWid && 1.3 > pixHgt/pixWid
        if pixWid < size(vidFrame,2)/2 && topCol+pixWid<size(vidFrame,2) % avoid false detections in smaller watchBox
            recs{1,end+1} = [topCol topRow  pixWid pixHgt];
        end
    end
end


end