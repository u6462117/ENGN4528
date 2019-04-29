function detectRedBird(vidFrame)
R = vidFrame(:,:,1);
G = vidFrame(:,:,2);
B = vidFrame(:,:,3);

result = (R > 117 & R < 219) .* (G < 89) .* (B > 13 & B < 116);
end