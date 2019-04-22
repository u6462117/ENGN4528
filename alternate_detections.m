clearvars();
close all;

%Read in data from specified time
v = VideoReader('Angry Birds In-game Trailer.avi');
v.currentTime = 15;
currAxes = axes;
vidFrame = readFrame(v);

%Display frame
image(vidFrame, 'Parent', currAxes);

%Slice
figure()
slice = vidFrame(90:110,60:80,:);
imshow(slice);

%Display histogram of red channel
figure();
imhist(slice(:,:,1))
title('Red')

figure();
imhist(slice(:,:,2))
title('Green')

figure();
imhist(slice(:,:,3))
title('Blue')



