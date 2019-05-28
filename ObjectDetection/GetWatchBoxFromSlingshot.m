function [watchBoxStruct] = GetWatchBoxFromSlingshot(slingshotLoc, currFrame)
    
    loc = slingshotLoc{1};
    mem = OffsetFromSlingshot(slingshotLoc, currFrame);
    

    watchBoxStruct = struct('Location', loc, 'Memory', mem);
end


