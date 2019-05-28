function [recs, memory] = Draw(prompt, currFrame, prevFrame, h,time, memory)

    recs = [];

    if strcmp(prompt, 'All')
%         cla('reset');
%         imshow(currFrame);
        set(h,'Cdata',currFrame);
        recs = DrawAllBoxes(currFrame);
        
    elseif strcmp(prompt, 'None')
%         cla('reset');
        set(h,'Cdata',currFrame);
%         imshow(currFrame);
        
    else
        [recs, memory] = DrawBoxesAndTraj(prompt, currFrame, prevFrame, h,time, memory);
        
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

function [recs, memory] = DrawBoxesAndTraj(prompt, currFrame, prevFrame, h,time, memory)


%     imshow(currFrame);
    set(h,'Cdata',currFrame);

    recs = [];
    
    if      strcmp(prompt, 'Red')
        bird = detectRedBird(currFrame);
        recs = DrawRectangles(bird, 'red', recs);
        
    elseif  strcmp(prompt, 'Yellow')
        bird = detectYellowBird(currFrame);
        recs = DrawRectangles(bird, 'yellow', recs);
        
    elseif  strcmp(prompt, 'White')
        bird = detectWhiteBird(currFrame);
        recs = DrawRectangles(bird, 'white', recs);
        
    elseif  strcmp(prompt, 'Blue')
        bird = detectBlueBird(currFrame);
        recs = DrawRectangles(bird, 'blue', recs);
        
    elseif  strcmp(prompt, 'Black')
        bird = detectBlackBird(currFrame);
        recs = DrawRectangles(bird, 'black', recs);
        
    end
    
    %pigs
    grenPigs = detectGreenPigs(currFrame);
    recs = DrawRectangles(grenPigs, 'green', recs);

    
    %
    if ~isempty(bird)
        bird = bird{1};
     
        [movingReg, TBetter] = FindBetterCorrespondences(prevFrame, currFrame);
        if isa(movingReg.Transformation,'affine2d')
            [trajX, trajY] = FindQuadratic(bird, TBetter, 0.1);
            fhand = plot(trajX, trajY);

            recs = [recs, fhand];
        end

    end

    
end