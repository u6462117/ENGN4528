function [recs] = detectGreenPigs(vidFrame)
R = vidFrame(:,:,1);
G = vidFrame(:,:,2);
B = vidFrame(:,:,3);

result = (R > 120 & R < 165) .* (G > 190 & G<260) .* (B > 35 & B < 120);

se = strel('disk',8);
result = imclose(result,se);

thresh = 35;

CC          = bwconncomp(result);
val         = cellfun(@(x) numel(x),CC.PixelIdxList);
birdsFound  = CC.PixelIdxList(val>thresh);

recs = cell(1,0);

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