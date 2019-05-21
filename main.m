close all;
clearvars();
global pano;
v = VideoReader("Angry Birds In-game Trailer.avi");


%% Variables
test = false;

%time
time = 10;
dt = 0.1;
slingshotTimeout = 7;
slingshotDetectTime = -9999;

slingshotFound = false;
birdFlying = false;
stitch = false;

watchBoxStruct = struct('Location', NaN(1,4), 'Memory', NaN(10,10));
prevFrame = NaN;
prompt = 'None';
pano = NaN;

%% Main Loop

figure();

while hasFrame(v)
    %% Setup
    currFrame = readFrame(v);
    
    %% Mode Identifiaction
    if (time - slingshotDetectTime) > slingshotTimeout
        
        %Detect slingshot
        [slingshotFound, slingshotLoc] = detectSlingshot(currFrame);
        
        %If slingshot found, declare Watch Box.
        if slingshotFound
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
                
            end
            
        end
        
        
    end
    
    
    %% Draw New Frame
    Draw(prompt, currFrame, prevFrame);
    
    %% Tidy Up
    time = time + dt;
    if time < 20
        v.CurrentTime = time;
    end
    prevFrame = currFrame;

end