function [recs] = detectRedBird(vidFrame)
% DETECTREDBIRD  Look for any red birds in the video frame.
%   [recs] = DETECTGREENPIGS(vidFrame) looks for any red birds in the
%   video frame and returns all the red birds detected in matrix form
%

R = vidFrame(:,:,1);
G = vidFrame(:,:,2);
B = vidFrame(:,:,3);

result = (R > 117 & R < 219) .* (G < 89) .* (B > 13 & B < 116);

thresh = 50;

CC          = bwconncomp(result);
val         = cellfun(@(x) numel(x),CC.PixelIdxList);
birdsFound  = CC.PixelIdxList(val>thresh);

recs = cell(1,0);

for bird = 1:length(birdsFound)
    pixels = birdsFound{bird};
    [rows, cols] = ind2sub(size(vidFrame), pixels);
    
    topRow = min(rows) - 10;
    topCol = min(cols) - 10;
    pixWid = max(cols) - min(cols) + 20;
    pixHgt = max(rows) - min(rows) + 20;
    
    % Remove objects that do not meet the expected aspect ratio of the
    % bird
    if 0.7 < pixHgt/pixWid && 1.3 > pixHgt/pixWid
        recs{1,end+1} = [topCol topRow  pixWid pixHgt];
    end
end


end