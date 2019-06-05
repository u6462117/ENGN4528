function [recs, worldPoints] = Draw(prompt, currFrame, prevFrame, fHand, worldPoints, dt)
%Draw This function draws the most recent frame and also any overlays like
%bounding boxes and trajectories. This behaviour is governed by prompt,
%which can have a value as a bird colour (e.g. 'Red', 'Blue'), 'All' to
%draw all birds and pigs or 'None' to draw only the frame. fHand is the
%function handle of the figure, to be updated. 

    %Hold the function handles of any plot overlays
    recs = [];

    %If 'All', draw all birds and pigs
    if strcmp(prompt, 'All')
        %Update the figure
        set(fHand,'Cdata',currFrame);
        recs = DrawAllBoxes(currFrame);
    
    %If 'None' draw only the current frame
    elseif strcmp(prompt, 'None')
        %Update the figure
        set(fHand,'Cdata',currFrame);
    
    %If a specific colour, draw the boxes for that colour and the trajectory.  
    else
        %Update the figure
        set(fHand,'Cdata',currFrame);
        [recs, worldPoints] = DrawBoxesAndTraj(prompt, currFrame, prevFrame, worldPoints, dt);
        
    end
    
end


function [recs] = DrawAllBoxes(currFrame)
%DrawAllBoxes This function draws bounding boxes around all bird and pig
%colours and returns their function handles as recs

%Hold the function handles of any plot overlays
recs = [];

hold on;

redBirds = detectRedBird(currFrame);
recs = DrawRectangles(redBirds, 'red', recs);

bluBirds = detectBlueBird(currFrame);
recs = DrawRectangles(bluBirds, 'blu', recs);

yelBirds = detectYellowBird(currFrame);
recs = DrawRectangles(yelBirds, 'yellow', recs);
        
blkBirds = detectBlackBird(currFrame);
recs = DrawRectangles(blkBirds, 'black', recs);

whtBirds = detectWhiteBird(currFrame);
recs = DrawRectangles(whtBirds, 'white', recs);

grenPigs = detectGreenPigs(currFrame);
recs = DrawRectangles(grenPigs, 'green', recs);


end

function [recs, worldPoints] = DrawBoxesAndTraj(prompt, currFrame, prevFrame, worldPoints, dt)
    
    %Hold the function handles of any plot overlays
    recs = [];

    %Find the flying bird and draw its bounding box
    if      strcmp(prompt, 'Red')
        birds = detectRedBird(currFrame);
        recs = DrawRectangles(birds, 'red', recs);
        
    elseif  strcmp(prompt, 'Yellow')
        birds = detectYellowBird(currFrame);
        recs = DrawRectangles(birds, 'yellow', recs);
        
    elseif  strcmp(prompt, 'White')
        birds = detectWhiteBird(currFrame);
        recs = DrawRectangles(birds, 'white', recs);
        
    elseif  strcmp(prompt, 'Blue')
        birds = detectBlueBird(currFrame);
        recs = DrawRectangles(birds, 'blue', recs);
        
    elseif  strcmp(prompt, 'Black')
        birds = detectBlackBird(currFrame);
        recs = DrawRectangles(birds, 'black', recs);
        
    end
    
    grenPigs = detectGreenPigs(currFrame);
    recs = DrawRectangles(grenPigs, 'green', recs);

    
    %Draw bird trajectory
    if ~isempty(birds)
        
        %Extract the flying bird
        bird = birds{1};
        
        %Find correspondences between the frames to obtain scaling and
        %translation information
        [movingReg, T] = FindCorrespondences(prevFrame, currFrame);
        if isa(movingReg.Transformation,'affine2d')
            
            %Pass this to FindQuadratic, which will fit to worldPoints
            [trajX, trajY, worldPoints] = FindQuadratic(bird, T, dt, worldPoints);
            
            %Plot the bird's trajectory and return its handle
            trajLine = plot(trajX, trajY, 'r', 'Linewidth', 3);
            trajLine.Color(4) = 0.7;
            recs = [recs, trajLine];
        end

    end

    
end