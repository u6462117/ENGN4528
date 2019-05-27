function [watchBoxNow] = OffsetFromSlingshot(slingshotLoc, currFrame)

    rec = slingshotLoc{1};
    
    try
        watchBoxNow = ...
            currFrame( rec(2)-80:rec(2) +20,rec(1) + rec(3) + 10 :rec(1) + rec(3) + 135,:);
    catch

        watchBoxNow = ...
            currFrame( rec(2)-50:end,rec(1) + rec(3) :min(rec(1) + rec(3) + 75,end),:);
    end
    
    
%     imshow(currFrame);
%     rectangle('Position', rec);
end