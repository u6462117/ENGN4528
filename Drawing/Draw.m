function [] = Draw(prompt, currFrame, prevFrame)

    if strcmp(prompt, 'All')
        cla('reset');
        imshow(currFrame);
        recs = DrawAllBoxes(currFrame);
        
    elseif strcmp(prompt, 'None')
        cla('reset');
        imshow(currFrame);
        
    else
        recs = DrawBoxesAndTraj(prompt, currFrame, prevFrame);
        
    end
    
%     imshow(currFrame);
%     [ssf, ssl] = detectSlingshot(currFrame);
%     if ssf
%         recs = DrawRectangles(ssl, 'magenta', recs);
%     end
    
    pause(0.03);
    if exist('recs', 'var')
        delete(recs);
    end
    

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


end

function [recs] = DrawBoxesAndTraj(prompt, currFrame, prevFrame)

%     pano = StitchFromTime2(prevFrame, currFrame);
%     imshow(pano);
    
    imshow(currFrame);

    
    recs = [];
    
%     if      strcmp(prompt, 'Red')
%         redBirds = detectRedBird(currFrame);
%         recs = DrawRectangles(redBirds, 'red', recs);
%         
%     elseif  strcmp(prompt, 'Yellow')
%         yelBirds = detectYellowBird(currFrame);
%         recs = DrawRectangles(yelBirds, 'yellow', recs);
%         
%     elseif  strcmp(prompt, 'White')
%         whtBirds = detectWhiteBird(currFrame);
%         recs = DrawRectangles(whtBirds, 'white', recs);
%         
%     elseif  strcmp(prompt, 'Blue')
%         bluBirds = detectBlueBird(currFrame);
%         recs = DrawRectangles(bluBirds, 'blue', recs);
%         
%     elseif  strcmp(prompt, 'Black')
%         blkBirds = detectBlackBird(currFrame);
%         recs = DrawRectangles(blkBirds, 'black', recs);
%         
%     end
%     
%     %pigs
%     grenPigs = detectGreenPigs(currFrame);
%     recs = DrawRectangles(grenPigs, 'green', recs);
    
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
        try
            movingReg = FindCorrespondences(prevFrame, currFrame);
            T = movingReg.Transformation.T;
            [trajX, trajY] = FindQuadratic(bird, T);
            fhand = plot(trajX, trajY);
            
            recs = [recs, fhand];
        catch
        end
    end

    
end
