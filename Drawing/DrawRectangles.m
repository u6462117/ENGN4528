function [recs] = DrawRectangles(objects, col, recs)
    if ~isempty(objects)
        for i = 1:length(objects)
            fhand = rectangle('Position', objects{i},'EdgeColor',col, 'LineWidth',2);
            recs = [recs, fhand];
        end
    end
end