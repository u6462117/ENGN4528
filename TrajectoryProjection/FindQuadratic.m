function [trajX, trajY, worldPoints] = FindQuadratic(bird, T, dt, worldPoints)
% FindQuadratic  Finds the quadratic which describes the trajectory of bird
% using the transformation matrix T, the time difference between frames,
% dt, in seconds and the list of parabola points worldPoints.

%Translate points to the middle of the bird
birdX2 = bird(1) + bird(3)/2;
birdY2 = bird(2) + bird(4)/2;

%Extract the scaling and translation
sx = sqrt(T(1,1)^2 + T(1,2)^2);
sy = sqrt(T(2,1)^2 + T(2,2)^2);
tx = T(3,1);
ty = T(3,2);

%Find the previous bird location in the frame2 coordinate system
[birdX1, birdY1] = ConvertFrames(birdX2,birdY2,...
                                tx, ty, sx, sy);

%Append the new points to worldPoints
[worldPoints] = AddWorldPoints(birdX2, birdY2, worldPoints, tx, ty, sx, sy);

%Plot the trajectory using the kinematic approximation
[trajX, trajY] = FindTimeSeries(birdX1, birdY1,birdX2, birdY2,dt);

%If enough points are available, use the polyval approximation
if size(worldPoints, 1) > 4 
    
    %Prevent jumping of the trajectory by checking against the last known
    %worldPoint
    closeEnough = (abs(worldPoints(end,1) - worldPoints(end-1,1)) + ...
                    abs(worldPoints(end,2) - worldPoints(end-1,2))) < 50;
   
    %Fit the trajectory with polyfit
    if closeEnough
        
        qFit = polyfit(worldPoints(:,1), worldPoints(:,2), 2);
        trajX = [birdX2:1:5*birdX2];
        trajY = polyval(qFit, trajX);
    end
end


end

function [x,y] = ConvertFrames(x, y, tx, ty, sx, sy)
% ConvertFrames Converts x and y (which are in frame1) to frame2

x = 1/sx * (x - tx);
y = 1/sy * (y - ty);

end


function [x,y] = FindTimeSeries(x1, y1, x2, y2, dt)
% FindTimeSeries This function finds the trajectory using the kinematic
% approximation. It approximates the velocity of the bird using the
% difference in position between the two frames and then applies the
% equations based on projectile motion:
%           x = xAv + vx * t;
%           y = yAv + vy * t + 1/2 * 10 * t.^2;

g = 9.8; %m/s^2

%Find the position differences (and thus velocity)
xDiff = (x2 - x1);
yDiff = (y2 - y1);
xAv = (x2 + x1)/2;
yAv = (y2 + y1)/2;

vx = xDiff/dt;
vy = yDiff/dt;

%Define the plot range
tPlot = ceil(abs(2*yDiff/vy) + abs(2*xDiff/vx));
if isnan(tPlot)
    t = [0:0.1*dt:100*dt];
else
    t = [0:0.1*dt:10*tPlot];
end

%Find the points on the trajectory
x = xAv + vx * t;
y = yAv + vy * t + 1/2 * g * t.^2;
end


function[worldPoints] = AddWorldPoints(birdX2, birdY2, worldPoints, tx, ty, sx, sy)
% AddWorldPoints This function does the same procedure as ConvertFrames,
% but for every point in the worldPoints vector. It returns worldPoints,
% which are all in the coordinate frame2.

    numPoints = size(worldPoints,1);
    
    %Translate previous points to the new coordinate frame
    if ~isempty(worldPoints)

        worldPoints = worldPoints - [tx * ones(numPoints, 1), ty * ones(numPoints, 1) ];
        worldPoints(:,1) = 1/sx * worldPoints(:,1);
        worldPoints(:,2) = 1/sy * worldPoints(:,2);
    end
    
    %Append the new points
    worldPoints = [worldPoints; birdX2, birdY2];

end