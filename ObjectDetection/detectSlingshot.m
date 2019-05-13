function [boolSlingshotFound, recs] = detectSlingshot(vidFrame)
% R = vidFrame(:,:,1);
% G = vidFrame(:,:,2);
% B = vidFrame(:,:,3);
% 
% result = (R > 138 & R < 187) .* (G > 85 & G < 152) .* (B > 33 & B < 185);

%% RGB
I = vidFrame;

% Define thresholds for channel 1 based on histogram settings
channel1Min = 153.000;
channel1Max = 169.000;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 70.000;
channel2Max = 128.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 11.000;
channel3Max = 70.000;

% Create mask based on chosen histogram thresholds
result = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);

% %% HSV
% % Convert RGB image to chosen color space
% I = rgb2hsv(vidFrame);
% 
% % Define thresholds for channel 1 based on histogram settings
% channel1Min = 0.029;
% channel1Max = 0.126;
% 
% % Define thresholds for channel 2 based on histogram settings
% channel2Min = 0.234;
% channel2Max = 0.387;
% 
% % Define thresholds for channel 3 based on histogram settings
% channel3Min = 0.556;
% channel3Max = 0.766;
% 
% % Create mask based on chosen histogram thresholds
% result = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
%     (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
%     (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);

% %% LAB
% I = rgb2lab(vidFrame);
% 
% % Define thresholds for channel 1 based on histogram settings
% channel1Min = 0.000;
% channel1Max = 65.576;
% 
% % Define thresholds for channel 2 based on histogram settings
% channel2Min = -5.604;
% channel2Max = 10.907;
% 
% % Define thresholds for channel 3 based on histogram settings
% channel3Min = 23.020;
% channel3Max = 38.806;
% 
% % Create mask based on chosen histogram thresholds
% result = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
%     (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
%     (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);

thresh = 50; % 30 for RGB % 90 for LAB, only detects in scene with black bird


CC          = bwconncomp(result);
val         = cellfun(@(x) numel(x),CC.PixelIdxList);
slingshotFound  = CC.PixelIdxList(val > thresh); %& val < upThresh);

recs = cell(1,length(slingshotFound));

for slingshot = 1:length(slingshotFound)
    pixels = slingshotFound{slingshot};
    [rows, cols] = ind2sub(size(vidFrame), pixels);
    
    topRow = min(rows) - 40;
    topCol = min(cols) - 15;
    pixWid = max(cols) - min(cols) + 25;
    pixHgt = max(rows) - min(rows) + 80;
    
    recs{1,slingshot} = [topCol topRow  pixWid pixHgt];
end

boolSlingshotFound = ~isempty(slingshotFound);


end