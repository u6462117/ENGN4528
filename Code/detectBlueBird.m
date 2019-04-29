function detectBlueBird(vidFrame)
R = vidFrame(:,:,1);
G = vidFrame(:,:,2);
B = vidFrame(:,:,3);

result = (R > 100 & R < 110) .* (G > 139 & G < 169) .* (B > 153 & B > 196);
imagesc(result);
end