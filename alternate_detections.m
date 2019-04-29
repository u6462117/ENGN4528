clearvars();
close all;

%Read in data from specified time
v = VideoReader('Angry Birds In-game Trailer.avi');
v.currentTime = 15;
currAxes = axes;
vidFrame = readFrame(v);

% %Display frame
% image(vidFrame, 'Parent', currAxes);
% 
% %Slice
% figure()
slice = vidFrame(90:110,60:80,:);
% imshow(slice);
% 
% %Display histogram of red channel
% figure();
% imhist(slice(:,:,1))
% title('Red')
% 
% figure();
% imhist(slice(:,:,2))
% title('Green')
% 
% figure();
% imhist(slice(:,:,3))
% title('Blue')


%% 
% outIm = my_kmeans(vidFrame, 7, 'random', false);
% imagesc(outIm)

% 216,0,38
% 170,0,30

R = vidFrame(:,:,1);
G = vidFrame(:,:,2);
B = vidFrame(:,:,3);

%230,30,30

%result = (R>200 & R< 250) .* (G < 20) .* (B>20 & B<50);
result = (R>117 & R< 219) .* (G < 89) .* (B > 13 & B < 116);
imagesc(result);

figure()
result2 = (R > 120 & R < 165) .* (G > 190 & G<260) .* (B > 35 & B < 120);
imagesc(result2);

CC = bwconncomp(result);
selPixels = CC.PixelIdxList{1,1};

figure()
newFrame = zeros(size(result));
newFrame(selPixels) = 1;
imagesc(newFrame)

pt1 = selPixels(1);
pt2 = selPixels(end);

[rows, cols] = ind2sub(size(newFrame), [pt1 pt2]);
