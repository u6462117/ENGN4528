function detectGreenPigs(vidFrame)
R = vidFrame(:,:,1);
G = vidFrame(:,:,2);
B = vidFrame(:,:,3);

result = (R > 120 & R < 165) .* (G > 190 & G<260) .* (B > 35 & B < 120);
imagesc(result);
end