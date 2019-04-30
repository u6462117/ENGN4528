clearvars();
close all;

v = VideoReader('Angry Birds In-game Trailer.avi');

%% Read Frames
% v.CurrentTime = 15; %Red bird and pigs
% v.currentTime = 26; %Blue bird
% v.currentTime = 31; %Yellow bird
% v.currentTime = 39; %Black bird and pigs
 v.currentTime = 46; %White bird

theFrame = readFrame(v);

%% Detect Birds

%%%%% -------- Red Bird ---------- %%%%%
redBirds = detectRedBird(theFrame);

%%%%% -------- Blue Bird ---------- %%%%%
bluBirds = detectBlueBird(theFrame);

%%%%% -------- Yellow Bird ---------- %%%%%
yelBirds = detectYellowBird(theFrame);

%%%%% -------- Black Bird ---------- %%%%%
blkBirds = detectBlackBird(theFrame);

%%%%% -------- White Bird ---------- %%%%%
whtBirds = detectWhiteBird(theFrame);

%%%%% -------- Green Pigs ---------- %%%%%
grenPigs = detectGreenPigs(theFrame);

%% Display

figure();
imshow(theFrame); hold on;

DrawRectangles(redBirds, 'red');
DrawRectangles(bluBirds, 'blue');
DrawRectangles(yelBirds, 'yellow');
DrawRectangles(blkBirds, 'black');
DrawRectangles(whtBirds, 'white');
DrawRectangles(grenPigs, 'green');


function [] = DrawRectangles(birdsOrPigs, col)
    if ~isempty(birdsOrPigs)
        for i = 1:length(birdsOrPigs)
            rectangle('Position', birdsOrPigs{i},'EdgeColor',col)
        end
    end
end