function detectBlackBird(vidFrame)
R = vidFrame(:,:,1);
G = vidFrame(:,:,2);
B = vidFrame(:,:,3);

result = (R3 < 20) .* (G3 < 20) .* (B3 < 20);
imagesc(result);
end