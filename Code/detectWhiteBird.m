function detectWhiteBird(vidFrame)
R = vidFrame(:,:,1);
G = vidFrame(:,:,2);
B = vidFrame(:,:,3);

result = (R > 200 & R < 255) .* (G > 200 & G < 221) .* (B > 0 & B < 180);
imagesc(result);
end