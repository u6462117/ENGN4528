function [patchesMatch, watchBoxNow] = CompareWatchPatchWithMemory(currFrame, watchBoxStruct)
    patchesMatch = true;
    
    [slingshotFound, slingshotLoc] = detectSlingshot(currFrame);
    if slingshotFound
        slingshotLoc = slingshotLoc{1};
    else
       slingshotLoc = watchBoxStruct.Location;  
    end
    
    watchBoxMem = watchBoxStruct.Memory;
    
    watchBoxNow = OffsetFromSlingshot(slingshotLoc, currFrame);
    
    if sum(imabsdiff(watchBoxMem, watchBoxNow),'all') > 300000
        patchesMatch = false;
    end
end

