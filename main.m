close all;
clearvars();

v = VideoReader("Angry Birds In-game Trailer.avi");


%% Variables
time = 10;

flagSlingshotDetected = 0;
flagTimeSlingshot = 0;
flagBirdLaunched = 0;
currFrame = readFrame(v);
prevFrame = readFrame(v);
newScene = false;


%% Main Loop

figure();

while hasFrame(v)
    
    currFrame = readFrame(v);
    
    %% Slingshot detection
    if flagSlingshotDetected
        newScene = true;
        %Define the watch path
        rec = slingshotLoc{1};
        topRight = [rec(1), rec(2) + rec(4)];
        watchMe = currFrame(topRight(1):topRight(1)+20, topRight(2):topRight(2)+20);
        
    else
        flagTimeSlingshot = time;
        [flagSlingshotDetected,slingshotLoc] = detectSlingshot(currFrame);
    end
    
    
    
    if flagSlingshotDetected && newScene 
        
        watchPatch = currFrame(topRight(1):topRight(1)+20, topRight(2):topRight(2)+20);
        
        if sum(abs(watchMe - watchPatch).^2,'all') > 10
            flagBirdlaunched = true;
            
            %Find bird type
            %birdType = ;
        end
    end
    
    
    if flagSlingshotDetected && ~flagBirdLaunched
        draw = 'all';
    elseif flagSlingshotDetected && flagBirdLaunched
        draw = birdType;
    else
        draw = 'none';
    end
    
    DrawThem(draw, currFrame);
    
    %Update current time
    time = time + 0.1;
    v.CurrentTime = time;
    prevFrame = currFrame;
    
end

function [] = DrawThem(prompt, currFrame)

if strcmp(prompt,'all')
    imshow(currFrame);
    DrawThemAll(currFrame);
    
elseif strcmp(prompt, 'none')
    
    imshow(currFrame)
    
else %Specific colour
    keyboard;
    
end

end