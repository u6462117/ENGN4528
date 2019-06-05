function [recs] = detectBlackBird(vidFrame)
% DETECTBLACKBIRD  Look for any black birds in the video frame.
%   [recs] = DETECTBLACKBIRD(vidFrame) looks for any black birds in the
%   video frame and returns all the black birds detected in matrix form
%

%% Remove pause and score
vidFrame(1:65,1:65) = 0;
vidFrame(1:50,320:end) = 0;
vidFrame(260:end,422:end) = 0;

% Convert RGB image to chosen color space
I = vidFrame;

% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.000;
channel1Max = 103.000;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.000;
channel2Max = 107.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.000;
channel3Max = 115.000;

% Create mask based on chosen histogram thresholds
result = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);

thresh = 140;

CC          = bwconncomp(result);
val         = cellfun(@(x) numel(x),CC.PixelIdxList);
birdsFound  = CC.PixelIdxList(val > thresh);

recs = cell(1,0);

for bird = 1:length(birdsFound)
    pixels = birdsFound{bird};
    [rows, cols] = ind2sub(size(vidFrame), pixels);
    
    topRow = min(rows) - 15;
    topCol = min(cols) - 10;
    pixWid = max(cols) - min(cols) + 20;
    pixHgt = max(rows) - min(rows) + 25;
    
    % Remove objects that do not meet the expected aspect ratio of the
    % bird
    if 0.7 < pixHgt/pixWid && 1.3 > pixHgt/pixWid
        if pixWid <50 % determined empirically
            recs{1,end+1} = [topCol topRow  pixWid pixHgt];
        end
    end
end



end