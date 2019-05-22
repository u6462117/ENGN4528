%% Try other than hsv
function [recs] = detectYellowBird(vidFrame)
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

%remove pause button and menu
result(1:60,1:60) = 0; %remove pause button
result(1:60,320:end) = 0; %remove score

thresh = 190;
upThresh = 400;


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
        recs{1,end+1} = [topCol topRow  pixWid pixHgt];
    end
end


end