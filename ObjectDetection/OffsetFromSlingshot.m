function [watchBoxNow] = OffsetFromSlingshot(slingshotLoc, currFrame)

    rec = slingshotLoc{1};
    
    try
        watchBoxNow = ...
            currFrame( max(1,rec(2)-80):rec(2) +20,rec(1) + rec(3) + 10 :rec(1) + rec(3) + 135,:);
    catch

        watchBoxNow = NaN;
    end
    
    
%     imshow(currFrame);
%     rectangle('Position', rec);
end