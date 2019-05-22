function [watchBoxStruct] = GetWatchBoxFromSlingshot(slingshotLoc, currFrame)
    
%     loc = slingshotLoc;
%     slingshotLoc = slingshotLoc{1};
    loc = slingshotLoc{1};
    mem = OffsetFromSlingshot(slingshotLoc, currFrame);
    

    watchBoxStruct = struct('Location', loc, 'Memory', mem);
end


