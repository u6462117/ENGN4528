close all;
clearvars();

v = VideoReader("Angry Birds In-game Trailer.avi");

%% Variables

%time
time = 10;
dt = 0.1;
slingshotTimeout = 7;
slingshotDetectTime = -9999;

slingshotFound = false;
birdFlying = false;

watchBoxStruct = struct('Location', NaN(1,4), 'Memory', NaN(10,10));
prevFrame = NaN;
prompt = 'None';
plotOverlays = [];
worldPoints = [];
i = 1;

%% Main Loop

figure();
h = imshow(readFrame(v));

while time < 66.1
    %% Setup
    currFrame = readFrame(v);

    %% Mode Identifiaction
    if (time - slingshotDetectTime) > slingshotTimeout
        
        %Detect slingshot
        [slingshotFound, slingshotLoc] = detectSlingshot(currFrame);
        
        %If slingshot found, declare Watch Box.
        if slingshotFound
            birdFlying = false;
            worldPoints = [];
            slingshotDetectTime = time;
            watchBoxStruct = GetWatchBoxFromSlingshot(slingshotLoc, currFrame);
            prompt = 'All';
        else
            if ~birdFlying
                prompt = 'None';
            end
        end
          
    else %If less than timeout period
        
        if ~birdFlying
            
            [patchesMatch, watchBoxNow] = ...
                CompareWatchPatchWithMemory(currFrame, watchBoxStruct);
            
            if patchesMatch
                prompt = 'All';
                
            else
                
                mainBird = FindMainBird(watchBoxNow);                
                birdFlying = true;
                prompt = mainBird;
                disp(mainBird);
                
            end
            
        end
        
        
    end
    
    
    %% Draw New Frame
    if time > 60
       prompt = 'None'; 
    end
    
    delete(plotOverlays);
    [plotOverlays, worldPoints] = Draw(prompt, currFrame, prevFrame, h, worldPoints);
    
    %% Tidy Up
    time = time + dt;
    if time < 62
        v.CurrentTime = time;
    end
    prevFrame = currFrame;
    F(i) = getframe(gcf);
    i = i+1;
end

delete(plotOverlays);

% create the video writer with 1 fps
writerObj = VideoWriter('myVideo.avi');
writerObj.Quality = 95;
writerObj.FrameRate = 20;


open(writerObj);
% write the frames to the video
for i=1:length(F)
    % convert the image to a frame
    frame = F(i) ;
    writeVideo(writerObj, frame);
end
% close the writer object
close(writerObj);