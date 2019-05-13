function [gndVect] = detectTheGround(vidFrame, t)
gndVect = size(vidFrame,1) * ones(1,size(vidFrame,2));

% figure();
% imshow(vidFrame)

result = ThreshFromT(vidFrame, t);
% figure()
% imagesc(result)

output = bwlabel(result,4);

for i = 1:length(gndVect)
    [new,~] = find(output(:,i),1);
    
    if ~isempty(new)
         gndVect(i) = new;
    end
end

% figure()
% plot(gndVect)
end

function [result] = ThreshFromT(vidFrame, t)

R = vidFrame(:,:,1);
G = vidFrame(:,:,2);
B = vidFrame(:,:,3);

%Segment by scenes
if t > 10 && t < 35
    result = (R > 10 & R < 35) .* (G > 20 & G < 50) .* (B > 70 & B < 100);
elseif t >= 35 && t < 45
    result = (R > 85 & R < 105) .* (G > 40 & G < 60) .* (B > 30 & B < 45);
elseif t >= 45 && t < 55
    result = (R > 20 & R < 45) .* (G > 40 & G < 65) .* (B > 20 & B < 45);
elseif t > 55 && t < 60
    result = (R > 90 & R < 120) .* (G > 80 & G < 100) .* (B > 70 & B < 100);
    result(1:220,:) = 0;
end


end