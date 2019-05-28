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

%Export video?
exportVideo = false;
storedFrames = [];
i = 1;

%% Main Loop

figure();
fHand = imshow(readFrame(v));

while time < v.Duration
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
            prompt = 'All';
        else
            if ~birdFlying
                prompt = 'None';
            end
        end
          
    else %If less than timeout period
        
        if ~birdFlying
            
            [prompt, mainBird] = CheckWatchBox(currFrame);

            if ~strcmp(prompt, 'All')

                birdFlying = true;
                disp([mainBird ' bird is flying!']);
                
            end
            
        end
        
        
    end
    
    
    %% Draw New Frame
    
    delete(plotOverlays);
    [plotOverlays, worldPoints] = Draw(prompt, currFrame, prevFrame, fHand, worldPoints, dt);
    
    %% Tidy Up
    time = time + dt;
    if time < v.Duration
        v.CurrentTime = time;
    end
    
    prevFrame = currFrame;
    
    if time > v.Duration - 6.5
       prompt = 'None'; 
    end
    
    if exportVideo
        storedFrames(i) = getframe(gcf);
        i = i+1;
    end
    

end

%% Export video, if requested
if exportVideo
    % create the video writer with 20 fps
    writerObj = VideoWriter('AngryBirdsAnnotated.avi');
    writerObj.Quality = 95;
    writerObj.FrameRate = 20;
    
    % write the frames to the video
    open(writerObj);
    for i=1:length(F)
        % convert the image to a frame
        frame = F(i) ;
        writeVideo(writerObj, frame);
    end
    % close the writer object
    close(writerObj);
end
