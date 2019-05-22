function [watchBoxNow] = OffsetFromSlingshot(slingshotLoc, currFrame)

    rec = slingshotLoc;
    
    try
        watchBoxNow = ...
            currFrame( rec(2)-80:rec(2) +20,rec(1) + rec(3) :rec(1) + rec(3) + 125,:);
    catch
        watchBoxNow = ...
            currFrame( rec(2)-50:end,rec(1) + rec(3) :rec(1) + rec(3) + 75,:);
    end
    
    
    imshow(currFrame);
    rectangle('Position', rec);
end