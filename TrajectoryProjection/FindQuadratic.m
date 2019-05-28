function [trajX, trajY, worldPoints] = FindQuadratic(bird, T, dt, worldPoints)
persistent runningOX;
persistent runningOY;

if isempty(worldPoints)
    runningOX = 0;
    runningOY = 0;
end

birdX2 = bird(1) + bird(3)/2;
birdY2 = bird(2) + bird(4)/2;

sx = sqrt(T(1,1)^2 + T(1,2)^2);
sy = sqrt(T(2,1)^2 + T(2,2)^2);
% sx = T(1,1);
% sy = T(2,2);
tx = T(3,1);
ty = T(3,2);

[birdX1, birdY1] = ConvertFrames(birdX2,birdY2,...
                                tx, ty, sx, sy);
                            
% [birdX2p, birdY2p] = ConvertBackFrames(birdX2,birdY2,...
%                                 tx, ty, sx, sy);
                            
[worldPoints] = AddWorldPoints(birdX2, birdY2, worldPoints, tx, ty, sx, sy);

% worldPoints = [worldPoints; birdX2p, birdY2p];

% runningOX = runningOX + tx;
% runningOY = runningOY + ty;


[trajX, trajY] = FindTimeSeries(birdX1, birdY1,...
    birdX2, birdY2,dt);

if size(worldPoints, 1) > 4 
    
    closeEnough = (abs(worldPoints(end,1) - worldPoints(end-1,1)) + ...
                    abs(worldPoints(end,2) - worldPoints(end-1,2))) < 50;
   
    if closeEnough
        
        qFit = polyfit(worldPoints(:,1), worldPoints(:,2), 2);
        trajX = [birdX2:1:5*birdX2];
        trajY = polyval(qFit, trajX);
    end
end


end

function [x,y] = ConvertFrames(x, y, tx, ty, sx, sy)


x = 1/sx * (x - tx);
y = 1/sy * (y - ty);

end

function [x,y] = ConvertBackFrames(x, y, tx, ty, sx, sy)


x = sx * (x + tx);
y = sy * (y + ty);

end

function [x,y] = FindTimeSeries(x1, y1, x2, y2, dt)


xDiff = (x2 - x1);
yDiff = (y2 - y1);
xAv = (x2 + x1)/2;
yAv = (y2 + y1)/2;

vx = xDiff/dt;
vy = yDiff/dt;

tPlot = ceil(abs(2*yDiff/vy) + abs(2*xDiff/vx));
if isnan(tPlot)
    t = [0:0.1*dt:100*dt];
else
    t = [0:0.1*dt:10*tPlot];
end


x = xAv + vx * t;
y = yAv + vy * t + 1/2 * 10 * t.^2;
end


function[worldPoints] = AddWorldPoints(birdX2, birdY2, worldPoints, tx, ty, sx, sy)
    
    rows = size(worldPoints,1);
    
    if ~isempty(worldPoints)

        worldPoints = worldPoints - [tx * ones(rows, 1), ty * ones(rows, 1) ];
        worldPoints(:,1) = 1/sx * worldPoints(:,1);
        worldPoints(:,2) = 1/sy * worldPoints(:,2);
    end
    worldPoints = [worldPoints; birdX2, birdY2];

end