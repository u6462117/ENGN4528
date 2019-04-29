function detectBlackBird(vidFrame)
R = vidFrame(:,:,1);
G = vidFrame(:,:,2);
B = vidFrame(:,:,3);

result3 = (R3 < 20) .* (G3 < 20) .* (B3 < 20);
end