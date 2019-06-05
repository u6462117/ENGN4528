function [recs] = DrawRectangles(objects, col, recs)
%DrawRectangles This function draws rectangles around the objects in
%objects using the colour col. It then returns function handles to those
%rectangle objects at the end of the recs vector.

    if ~isempty(objects)
        for i = 1:length(objects)
            fhand = rectangle('Position', objects{i},'EdgeColor',col, 'LineWidth',2);
            recs = [recs, fhand];
        end
    end
end