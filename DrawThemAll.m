function [recs] = DrawThemAll(currFrame)

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

hold off;
pause(0.1);
delete(recs);


end

function [recs] = DrawRectangles(birdsOrPigs, col, recs)
    if ~isempty(birdsOrPigs)
        for i = 1:length(birdsOrPigs)
            fhand = rectangle('Position', birdsOrPigs{i},'EdgeColor',col, 'LineWidth',2);
            recs = [recs, fhand];
        end
    end
end

