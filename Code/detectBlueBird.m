function [recs] = detectBlueBird(vidFrame)
% R = vidFrame(:,:,1);
% G = vidFrame(:,:,2);
% B = vidFrame(:,:,3);
% 
% result = (R > 100 & R < 140) .* (G > 120 & G < 169) .* (B > 110 & B < 196);

% Convert RGB image to chosen color space
I = rgb2ycbcr(vidFrame);

% Define thresholds for channel 1 based on histogram settings
channel1Min = 42.000;
channel1Max = 162.000;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 112.000;
channel2Max = 140.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 85.000;
channel3Max = 125.000;

% Create mask based on chosen histogram thresholds
result = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);

thresh = 60; % 76 lowest blue bird, 80 false detection
upThresh = 110;

CC          = bwconncomp(result);
val         = cellfun(@(x) numel(x),CC.PixelIdxList);
birdsFound  = CC.PixelIdxList(val > thresh & val < upThresh);

recs = cell(1,length(birdsFound));

for bird = 1:length(birdsFound)
    pixels = birdsFound{bird};
    [rows, cols] = ind2sub(size(vidFrame), pixels);
    
    topRow = min(rows) - 10;
    topCol = min(cols) - 10;
    pixWid = max(cols) - min(cols) + 20;
    pixHgt = max(rows) - min(rows) + 20;
    
    recs{1,bird} = [topCol topRow  pixWid pixHgt];
end


end