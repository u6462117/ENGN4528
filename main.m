clearvars();
close all;

v = VideoReader('Angry Birds In-game Trailer.avi');

frame1 = read(v, 440);
frame2 = read(v, 445);

[bw1, f1p] = RemoveBackground(frame1);
[bw2, f2p] = RemoveBackground(frame2);

figure();
imagesc(f1p);

figure();
imagesc(f2p);