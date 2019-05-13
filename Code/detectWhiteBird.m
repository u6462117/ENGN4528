% Not HSV
function [recs] = detectWhiteBird(vidFrame)
% R = vidFrame(:,:,1);
% G = vidFrame(:,:,2);
% B = vidFrame(:,:,3);
% 
% result = (R  > 230) .* (G > 230) .* (B > 230);

% Convert RGB image to chosen color space
I = vidFrame;

% Define thresholds for channel 1 based on histogram settings
channel1Min = 240.000;
channel1Max = 255.000;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 242.000;
channel2Max = 255.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 229.000;
channel3Max = 255.000;

% Create mask based on chosen histogram thresholds
result = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);

thresh = 50; 
upThresh = 105;

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