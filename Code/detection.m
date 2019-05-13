% Slingshot falsely detected as brick in scene 6 but scene correctly
% identified
clearvars();
close all;

v = VideoReader('Angry Birds In-game Trailer.avi');
% time = 56;
% v.CurrentTime = time;

%% Read Frames
% v.CurrentTime = 15; %Red bird and pigs
% v.currentTime = 26; %Blue bird
% v.currentTime = 31; %Yellow bird
% v.currentTime = 39; %Black bird and pigs
% v.currentTime = 46; %White bird

i = 0;
count = 0;
% v.currentTime = 37; 
changeScene = [12 22 29 37 46 56];
firstAppearance = true;
while hasFrame(v)
    theFrame = readFrame(v);
    combinedString=strcat(int2str(i),'.jpg');
    
    figure();
    imshow(theFrame); hold on;
    %
    % slingsh = detectSlingshot(theFrame);
    % redBirds = detectRedBird(theFrame);
    % bluBirds = detectBlueBird(theFrame);
    % yelBirds = detectYellowBird(theFrame);
    % blkBirds = detectBlackBird(theFrame);
    % whtBirds = detectWhiteBird(theFrame);
    % DrawRectangles(slingsh, 'magenta');
    % DrawRectangles(redBirds, 'red');
    % DrawRectangles(bluBirds, 'blue');
    % DrawRectangles(yelBirds, 'yellow');
    % DrawRectangles(blkBirds, 'black');
    % DrawRectangles(whtBirds, 'white');
    
    % Start detection at 12 sec
    if v.currentTime > 11 & v.currentTime < 60
        % %%%%% -------- Slingshot ---------- %%%%%
        slingsh = detectSlingshot(theFrame);
        DrawRectangles(slingsh, 'magenta');
        
        if count < 6
            nextScene = changeScene(1,count+1);
        else
            nextScene = changeScene(1,6);
        end

        if v.currentTime >= nextScene
            firstAppearance = true;
            fprintf('-----' + string(firstAppearance) + '----\n');
        end
        
        if ~ isempty(slingsh) & firstAppearance
            count = count + 1;
            firstAppearance = false;
        end

        % trace firstAppear in the prev line
        title(string(v.currentTime) + ' sec, slingshot ' + string(~isempty(slingsh)) + ', firstAppear ' + string(firstAppearance) + ', nextScene ' + string(nextScene) + ', count ' + count);
        fprintf(string(v.currentTime) + ' sec, slingshot ' + string(~isempty(slingsh)) + ', firstAppear ' + string(firstAppearance) + ', nextScene ' + string(nextScene) + ', count ' + count + '\n');    
        
        if count == 1
            %%%%% -------- Red Birds ---------- %%%%%
            redBirds = detectRedBird(theFrame);
            DrawRectangles(redBirds, 'red');
        end
        
        if count == 2
            %%%%% -------- Blue + Red Birds ---------- %%%%%
            bluBirds = detectBlueBird(theFrame);
            DrawRectangles(bluBirds, 'blue');
            redBirds = detectRedBird(theFrame);
            DrawRectangles(redBirds, 'red');
        end
        
        if count == 3
            %%%%% -------- Yellow Birds ---------- %%%%%
            yelBirds = detectYellowBird(theFrame);
            DrawRectangles(yelBirds, 'yellow');
        end
        
        if count == 4
            %%%%% -------- Black + White Birds ---------- %%%%%
            blkBirds = detectBlackBird(theFrame);
            DrawRectangles(blkBirds, 'black');
            whtBirds = detectWhiteBird(theFrame);
            DrawRectangles(whtBirds, 'white');
        end
        
        if count == 5
            %%%%% -------- White Birds ---------- %%%%%
            whtBirds = detectWhiteBird(theFrame);
            DrawRectangles(whtBirds, 'white');
        end
        
        if count == 6
            %%%%% -------- Red Birds ---------- %%%%%
            redBirds = detectRedBird(theFrame);
            DrawRectangles(redBirds, 'red');
        end
        
        %%%%% -------- Green Pigs ---------- %%%%%
        grenPigs = detectGreenPigs(theFrame);
        DrawRectangles(grenPigs, 'green');
        
        %%%%% -------- The Ground ---------- %%%%%
        % tic;
        % gndVect = detectTheGround(theFrame, time);
        % t = toc;
        
    end
    
    %% cont from above while loop
    if v.currentTime >= 66
        break;
    end
    v.currentTime = v.currentTime + 1;
    %savefig(combinedString);
    saveas(gcf, combinedString);
    i = i + 1;
    
end

function [] = DrawRectangles(birdsOrPigs, col)
    if ~isempty(birdsOrPigs)
        for i = 1:length(birdsOrPigs)
            rectangle('Position', birdsOrPigs{i},'EdgeColor',col, 'LineWidth',2)
        end
    end
end