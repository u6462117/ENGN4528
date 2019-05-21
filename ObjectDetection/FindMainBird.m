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
