function [recs] = DrawRectangles(birdsOrPigs, col, recs)
    if ~isempty(birdsOrPigs)
        for i = 1:length(birdsOrPigs)
            fhand = rectangle('Position', birdsOrPigs{i},'EdgeColor',col, 'LineWidth',2);
            recs = [recs, fhand];
        end
    end
end