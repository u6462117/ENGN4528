function [prompt, mainBird] = CheckWatchBox(currFrame)
% CHECKWATCHBOX  Check whether the main bird is in the watch box.
%   [prompt, mainBird] = CHECKWATCHBOX(currFrame) checks if the main bird
%   is in the watch box in the current frame and returns the main bird (if
%   any) and the prompt for drawing
%

    prompt = 'All';
    mainBird = NaN;
    
    [slingshotFound, slingshotLoc] = detectSlingshot(currFrame);
    
    if slingshotFound

        watchBox = OffsetFromSlingshot(slingshotLoc, currFrame);
        mainBird = FindMainBird(watchBox);
        if ~isnan(mainBird)
            prompt = mainBird;
        end
        
    end
end