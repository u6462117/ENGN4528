function [recs, worldPoints] = Draw(prompt, currFrame, prevFrame, fHand, worldPoints, dt)

    recs = [];

    if strcmp(prompt, 'All')
        set(fHand,'Cdata',currFrame);
        recs = DrawAllBoxes(currFrame);
        
    elseif strcmp(prompt, 'None')
        set(fHand,'Cdata',currFrame);
        
    else
        [recs, worldPoints] = DrawBoxesAndTraj(prompt, currFrame, prevFrame, fHand, worldPoints, dt);
        
    end
    
%     [ssf, ssl] = detectSlingshot(currFrame);
%     if ssf
%         recs = DrawRectangles(ssl, 'magenta', recs);
%     end
    
end


function [recs] = DrawAllBoxes(currFrame)

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

function [recs, worldPoints] = DrawBoxesAndTraj(prompt, currFrame, prevFrame, fHand, worldPoints, dt)
    
    recs = [];

    %Reset the figure
    set(fHand,'Cdata',currFrame);

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
    
    %pigs
    grenPigs = detectGreenPigs(currFrame);
    recs = DrawRectangles(grenPigs, 'green', recs);

    
    %Draw bird trajectories
    if ~isempty(birds)
        bird = birds{1};
        
        [movingReg, T] = FindCorrespondences(prevFrame, currFrame);
        if isa(movingReg.Transformation,'affine2d')
            [trajX, trajY, worldPoints] = FindQuadratic(bird, T, dt, worldPoints);
            trajLine = plot(trajX, trajY, 'r', 'Linewidth', 3);
            trajLine.Color(4) = 0.7;

            recs = [recs, trajLine];
        end

    end

    
end