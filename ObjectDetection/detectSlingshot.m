function [boolSlingshotFound, recs] = detectSlingshot(vidFrame)
% R = vidFrame(:,:,1);
% G = vidFrame(:,:,2);
% B = vidFrame(:,:,3);
% 
% result = (R > 138 & R < 187) .* (G > 85 & G < 152) .* (B > 33 & B < 185);

% %% RGB
% I = vidFrame;
% 
% % Define thresholds for channel 1 based on histogram settings
% channel1Min = 153.000;
% channel1Max = 169.000;
% 
% % Define thresholds for channel 2 based on histogram settings
% channel2Min = 70.000;
% channel2Max = 128.000;
% 
% % Define thresholds for channel 3 based on histogram settings
% channel3Min = 11.000;
% channel3Max = 70.000;
% 
% % Create mask based on chosen histogram thresholds
% result = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
%     (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
%     (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);

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

min_thresh = 160; %determined empirically
max_thresh = 1500;

CC          = bwconncomp(result);
val         = cellfun(@(x) numel(x),CC.PixelIdxList);
slingshotFound  = CC.PixelIdxList(val > min_thresh & val<max_thresh); %& val < upThresh);

recs = cell(1,0);



for slingshot = 1:length(slingshotFound)
    pixels = slingshotFound{slingshot};
    [rows, cols] = ind2sub(size(vidFrame), pixels); %ind2sub is super slow. Can be updated to optimise

    topRow = min(rows);
    topCol = min(cols);
    pixWid = max(cols) - min(cols);
    pixHgt = max(rows) - min(rows);

    %Remove objects that don't meet the expected aspect ratio of the
    %slingshot
    if 54/20 < pixHgt/pixWid && 68/20 > pixHgt/pixWid        
        if 15<pixWid && 500>pixWid
            recs{1,end+1} = [topCol topRow  pixWid pixHgt];
        end
    end
    
end

if isempty(recs)
    boolSlingshotFound = 0;
elseif isempty(recs{1,1})
    boolSlingshotFound = 0;
else
    boolSlingshotFound = 1;
end


end