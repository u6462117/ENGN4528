function detectBlackBird(vidFrame)
R = vidFrame(:,:,1);
G = vidFrame(:,:,2);
B = vidFrame(:,:,3);

result = (R < 20) .* (G < 20) .* (B < 20);
imagesc(result);
end