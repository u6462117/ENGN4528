function detectYellowBird(vidFrame)
R = vidFrame(:,:,1);
G = vidFrame(:,:,2);
B = vidFrame(:,:,3);

result = (R4 > 200 & R4 < 255) .* (G4 > 200 & G4 < 221) .* (B4 > 0 & B4 < 180);
imagesc(result);
end