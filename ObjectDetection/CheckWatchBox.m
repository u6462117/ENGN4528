function [prompt, mainBird] = CheckWatchBox(currFrame)
    prompt = 'All';
    mainBird = NaN;
    
    [slingshotFound, slingshotLoc] = detectSlingshot(currFrame);
    
    if slingshotFound

        watchBox = OffsetFromSlingshot(slingshotLoc, currFrame);
        mainBird = FindMainBird(watchBox);
        if ~isnan(mainBird)
            prompt = mainBird;
        end
        
%         if ~isnan(mainBird)
%           patchesMatch = false;  
%         end
        
    end
end