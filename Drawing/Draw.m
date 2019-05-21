function [] = Draw(prompt, currFrame, prevFrame)

    if strcmp(prompt, 'All')
        imshow(currFrame);
        recs = DrawAllBoxes(currFrame);
        
    elseif strcmp(prompt, 'None')
        imshow(currFrame);
        
    else
        recs = DrawBoxesAndTraj(prompt, currFrame, prevFrame);
        
    end
    
%     imshow(currFrame);
%     [ssf, ssl] = detectSlingshot(currFrame);
%     if ssf
%         recs = DrawRectangles(ssl, 'magenta', recs);
%     end
    
    pause(0.1);
    if exist('recs', 'var')
        delete(recs);
    end
    

end

function [watchBoxStruct] = GetWatchBoxFromSlingshot(slingshotLoc, currFrame)
    
    loc = slingshotLoc;
    slingshotLoc = slingshotLoc{1};
    mem = OffsetFromSlingshot(slingshotLoc, currFrame);
    

    watchBoxStruct = struct('Location', loc, 'Memory', mem);
end

function [watchBoxNow] = OffsetFromSlingshot(slingshotLoc, currFrame)

    rec = slingshotLoc;
    
    try
        watchBoxNow = ...
            currFrame( rec(2)-80:rec(2) -20,rec(1) + rec(3) :rec(1) + rec(3) + 75,:);
    catch
        watchBoxNow = ...
            currFrame( rec(2)-50:end,rec(1) + rec(3) :rec(1) + rec(3) + 75,:);
    end
    
    
    imshow(currFrame);
    rectangle('Position', rec);
end

function [patchesMatch, watchBoxNow] = CompareWatchPatchWithMemory(currFrame, watchBoxStruct)
    patchesMatch = true;
    
    [slingshotFound, slingshotLoc] = detectSlingshot(currFrame);
    if slingshotFound
        slingshotLoc = slingshotLoc{1};
    else
       slingshotLoc = watchBoxStruct.Location;  
    end
    
    watchBoxMem = watchBoxStruct.Memory;
    
    watchBoxNow = OffsetFromSlingshot(slingshotLoc, currFrame);
    
    if sum(imabsdiff(watchBoxMem, watchBoxNow),'all') > 300000
        patchesMatch = false;
    end
end

function [mainBird] = FindMainBird(watchBoxNow)

    mainBird = NaN;

    %Detect the main bird
    
    %Red
    recs = detectRedBird(watchBoxNow);
    if ~isempty(recs)
        mainBird = 'Red';
    end
    
    %Yellow
    recs = detectYellowBird(watchBoxNow);
    if ~isempty(recs)
        mainBird = 'Yellow';
    end
    
    %White
    recs = detectWhiteBird(watchBoxNow);
    if ~isempty(recs)
        mainBird = 'White';
    end
    
    %Blue 
    recs = detectBlueBird(watchBoxNow);
    if ~isempty(recs)
        mainBird = 'Blue';
    end
    
    %Black 
    recs = detectBlackBird(watchBoxNow);
    if ~isempty(recs)
        mainBird = 'Black';
    end
    
    %assert(~isnan(mainBird));
    
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
    
    if      strcmp(prompt, 'Red')
        redBirds = detectRedBird(currFrame);
        recs = DrawRectangles(redBirds, 'red', recs);
        
    elseif  strcmp(prompt, 'Yellow')
        yelBirds = detectYellowBird(currFrame);
        recs = DrawRectangles(yelBirds, 'yellow', recs);
        
    elseif  strcmp(prompt, 'White')
        whtBirds = detectWhiteBird(currFrame);
        recs = DrawRectangles(whtBirds, 'white', recs);
        
    elseif  strcmp(prompt, 'Blue')
        bluBirds = detectBlueBird(currFrame);
        recs = DrawRectangles(bluBirds, 'blue', recs);
        
    elseif  strcmp(prompt, 'Black')
        blkBirds = detectBlackBird(currFrame);
        recs = DrawRectangles(blkBirds, 'black', recs);
        
    end
    
    %pigs
    grenPigs = detectGreenPigs(currFrame);
    recs = DrawRectangles(grenPigs, 'green', recs);
    
    %
    if ~isempty(redBirds)
        bird = redBirds{1};
        
        movingReg = FindCorrespondences(prevFrame, currFrame);
        T = movingReg.Transformation.T;
        [trajX, trajY] = PlotQuadratic(bird, T);
        fhand = plot(trajX, trajY);
        
        recs = [recs, fhand];
    end

    
end
