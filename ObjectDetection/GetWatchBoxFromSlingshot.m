function [watchBoxStruct] = GetWatchBoxFromSlingshot(slingshotLoc, currFrame)
    
    loc = slingshotLoc;
    slingshotLoc = slingshotLoc{1};
    mem = OffsetFromSlingshot(slingshotLoc, currFrame);
    

    watchBoxStruct = struct('Location', loc, 'Memory', mem);
end

function [watchBoxNow] = OffsetFromSlingshot(slingshotLoc, currFrame)

    rec = slingshotLoc;
    
    try
        watchBoxNow = ...
            currFrame( rec(2)-80:rec(2) -20,rec(1) + rec(3) :rec(1) + rec(3) + 75,:);
    catch
        watchBoxNow = ...
            currFrame( rec(2)-50:end,rec(1) + rec(3) :rec(1) + rec(3) + 75,:);
    end
    
    
    imshow(currFrame);
    rectangle('Position', rec);
end


