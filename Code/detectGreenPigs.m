function [recs] = detectGreenPigs(vidFrame)
R = vidFrame(:,:,1);
G = vidFrame(:,:,2);
B = vidFrame(:,:,3);

result = (R > 120 & R < 165) .* (G > 190 & G<260) .* (B > 35 & B < 120);

thresh = 28;

CC          = bwconncomp(result);
val         = cellfun(@(x) numel(x),CC.PixelIdxList);
birdsFound  = CC.PixelIdxList(val>thresh);

recs = cell(1,length(birdsFound));

for bird = 1:length(birdsFound)
    pixels = birdsFound{bird};
    [rows, cols] = ind2sub(size(vidFrame), pixels);
    
    topRow = min(rows) - 15;
    topCol = min(cols) - 15;
    pixWid = max(cols) - min(cols) + 25;
    pixHgt = max(rows) - min(rows) + 25;
    
    recs{1,bird} = [topCol topRow  pixWid pixHgt];
end


end