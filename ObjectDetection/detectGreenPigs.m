function [recs] = detectGreenPigs(vidFrame)
% DETECTGREENPIGS  Look for any green pigs in the video frame.
%   [recs] = DETECTGREENPIGS(vidFrame) looks for any green pigs in the
%   video frame and returns all the green pigs detected in matrix form
%

%Extract the red, green and blue channels
R = vidFrame(:,:,1);
G = vidFrame(:,:,2);
B = vidFrame(:,:,3);

%Construct a binary image using colour thresholding
result = (R > 120 & R < 165) .* (G > 190 & G<260) .* (B > 35 & B < 120);

%Perform closing
se = strel('disk',8);
result = imclose(result,se);

%Set the pixel cluster threshold
thresh = 35;

%Perform connected component analysis
CC          = bwconncomp(result);
val         = cellfun(@(x) numel(x),CC.PixelIdxList);
birdsFound  = CC.PixelIdxList(val>thresh);

recs = cell(1,0);

%Construct the bounding boxes for all pixel clusters which pass the tests
for bird = 1:length(birdsFound)
    pixels = birdsFound{bird};
    [rows, cols] = ind2sub(size(vidFrame), pixels);
    
    topRow = min(rows) - 15;
    topCol = min(cols) - 15;
    pixWid = max(cols) - min(cols) + 25;
    pixHgt = max(rows) - min(rows) + 25;
    
    if 0.8 < pixHgt/pixWid && 1.1 > pixHgt/pixWid
        recs{1,end+1} = [topCol topRow  pixWid pixHgt];
    end
end


end