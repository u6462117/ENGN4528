function [boolSlingshotFound, recs] = detectSlingshot(vidFrame)
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

se = strel('diamond',2);
result = imclose(result,se);

% % %% Close image
% % se = strel('disk',7);
% % result = imclose(result,se);

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
%     if (54/22 < pixHgt/pixWid && 68/17 > pixHgt/pixWid) || (45/16 < pixHgt/pixWid && 59/16 > pixHgt/pixWid)  
      if 2.4<pixHgt/pixWid && 4>pixHgt/pixWid
        if 15<=pixWid && 500>pixWid
            recs{1,end+1} = [topCol topRow  pixWid pixHgt];
        end
    end
    
end
if ~isempty(recs)
    recsCheck = recs{1};
    topCol = recsCheck(1);
    topRow = recsCheck(2);
    pixWid = recsCheck(3);
end

if isempty(recs)
    boolSlingshotFound = 0;
elseif isempty(recs{1,1})
    boolSlingshotFound = 0;
else
    if (topRow + 20 < 320) && (topCol + pixWid + 135 < 480)
        boolSlingshotFound = 1;
    else
        boolSlingshotFound = 0;
    end
end


end