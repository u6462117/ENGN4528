function [recs, movingRegs] = Draw(prompt, currFrame, prevFrame, h, movingRegs)

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
        [recs, movingRegs] = DrawBoxesAndTraj(prompt, currFrame, prevFrame, h, movingRegs);
        
    end
    
%     imshow(currFrame);
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


end

function [recs, movingRegs] = DrawBoxesAndTraj(prompt, currFrame, prevFrame, h, movingRegs)
    
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
        
        try
           cMR = FindCorrespondences(prevFrame, currFrame); 
           
           movingRegs = [movingRegs, cMR];
           
           if length(movingRegs) > 2
               
               
               movingRegs = movingRegs(2:end);
               
               TComb = eye(3);
               for i = 1:2
                   TComb = TComb * movingRegs(i).T;
               end
               
               fhand = plot(trajX, trajY);
               recs = [recs, fhand];
               
           end
            
        catch
            
        end
        
%         try
%             movingReg = FindCorrespondences(prevFrame, currFrame);
%             T = movingReg.Transformation.T;
%             [trajX, trajY] = FindQuadratic(bird, T);
%             fhand = plot(trajX, trajY);
%             
%             recs = [recs, fhand];
%         catch
%             
%         end
    end

    
end