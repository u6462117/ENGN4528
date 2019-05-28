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
    if(isempty(recs)) %yellow bird is sometimes identified as both yellow and white
        %This stops the yellow bird from ending the function while
        %classified as white
        recs = detectWhiteBird(watchBoxNow);
        if ~isempty(recs)
            mainBird = 'White';
        end
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
    
    
end
