function [recs] = detectBlueBird(vidFrame)
% R = vidFrame(:,:,1);
% G = vidFrame(:,:,2);
% B = vidFrame(:,:,3);
% 
% result = (R > 100 & R < 140) .* (G > 120 & G < 169) .* (B > 110 & B < 196);

% Convert RGB image to chosen color space
I = rgb2lab(vidFrame);

% Define thresholds for channel 1 based on histogram settings
channel1Min = 23.826;
channel1Max = 79.593;

% Define thresholds for channel 2 based on histogram settings
channel2Min = -19.391;
channel2Max = 2.523;

% Define thresholds for channel 3 based on histogram settings
channel3Min = -11.379;
channel3Max = 45.697;

% Create mask based on chosen histogram thresholds
result = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);

thresh = 60; % 76 lowest blue bird, 80 false detection
upThresh = 110;

CC          = bwconncomp(result);
val         = cellfun(@(x) numel(x),CC.PixelIdxList);
birdsFound  = CC.PixelIdxList(val > thresh & val < upThresh);

recs = cell(1,0);

for bird = 1:length(birdsFound)
    pixels = birdsFound{bird};
    [rows, cols] = ind2sub(size(vidFrame), pixels);
    
    topRow = min(rows);
    topCol = min(cols);
    pixWid = max(cols) - min(cols);
    pixHgt = max(rows) - min(rows);
    
    
    %Remove objects that don't meet the expected aspect ratio of the
    %bird
    if 0.7 < pixHgt/pixWid && 1.3 > pixHgt/pixWid
        recs{1,end+1} = [topCol topRow  pixWid pixHgt];
    end
end


end