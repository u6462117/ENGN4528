function detectBlueBird(vidFrame)
R = vidFrame(:,:,1);
G = vidFrame(:,:,2);
B = vidFrame(:,:,3);

result = (R2 > 100 & R2 < 110) .* (G2 > 139 & G2 < 169) .* (B2 > 153 & B2 > 196);
imagesc(result);
end