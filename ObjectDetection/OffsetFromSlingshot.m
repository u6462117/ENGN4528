function [watchBox] = OffsetFromSlingshot(slingshotLoc, currFrame)

rec = slingshotLoc{1};

watchBox = currFrame( max(1,rec(2)-80):rec(2) +20, ...
    rec(1) + rec(3) + 10 :rec(1) + rec(3) + 135,:);
    
end