function [patchesMatch, watchBoxNow] = CompareWatchPatchWithMemory(currFrame, watchBoxStruct)
    patchesMatch = true;
    watchBoxNow = NaN;
    
    [slingshotFound, slingshotLoc] = detectSlingshot(currFrame);
    
    if slingshotFound
%         slingshotLoc = slingshotLoc{1};

        watchBoxMem = watchBoxStruct.Memory;
        watchBoxNow = OffsetFromSlingshot(slingshotLoc, currFrame);
        
        mainBird = FindMainBird(watchBoxNow);
        if ~isnan(mainBird)
          patchesMatch = false;  
        end
        
%         if sum(imabsdiff(watchBoxMem, watchBoxNow),'all') > 700000
%             patchesMatch = false;
%         else
%             
%         end 
    end
end

