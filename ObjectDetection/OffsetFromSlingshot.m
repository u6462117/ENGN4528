function [watchBox] = OffsetFromSlingshot(slingshotLoc, currFrame)
% OffsetFromSlingshot This function takes in the location of the slingshot
% and the current frame and returns the watchBox, which is to the top right
% of the slingshot, ss.

%Extract the slingshot's bounding box
ss = slingshotLoc{1};

%Get the pixels in the watchbox, which is to the top-right of the slingshot
watchBox = currFrame( max(1,ss(2)-80):ss(2) +20, ...
    ss(1) + ss(3) + 10 :ss(1) + ss(3) + 135,:);
    
end