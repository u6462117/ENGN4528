clearvars();
close all;

frameDimX = 300;
frameDimY = 250;
boxX = 20;
boxY = 20;

Xdot = 10; %pixels per sec
Ydot = 10; %pixels per sec
dt = 1; %seconds

%% Make some example frames

[frame1, x1, y1] = GenerateFrame(frameDimX, frameDimY, 100, 100, boxX, boxY);
[frame2, x2, y2] = GenerateFrame(frameDimX, frameDimY, 130, 070, boxX, boxY);
[frame3, x3, y3] = GenerateFrame(frameDimX, frameDimY, 160, 050, boxX, boxY);

%% Convert coordinates

[x1,y1,x2,y2] = ConvertFrames(x1,y1,x2,y2,Xdot,Ydot,dt);

%% Find the quadratic represented by these points

%[a,b,c] = FindQuadratic(x1, y1, x2, y2, x3, y3);
[x,y] = FindQuadraticVel(x2, y2, x3, y3, dt);

%% Plot

figure()
hold on;
imagesc([0,frameDimY],[frameDimX,0],frame1)
pause(1)
imagesc([0,frameDimY],[frameDimX,0],frame2)
pause(1)
imagesc([0,frameDimY],[frameDimX,0],frame3)
pause(1)

figure();
hold on;
plot([x2, x3], [y2, y3], 'rx')
plot(x,y)
xlim([0 frameDimX])
ylim([0 frameDimY])
set(gca,'Ydir','reverse')

function [frame, cX, cY] = GenerateFrame(frameX, frameY, cornX, cornY, boxX, boxY)
%boxX, boxY are the x and y dimensions of the box
%cornX, cornY are the coordinates of the top left corner of the box

frame = zeros(frameY, frameX);

frame(cornY:cornY+boxY-1, cornX:cornX+boxX-1) = 1;

cX = round(cornX + 1/2 * boxX);
cY = round(cornY + 1/2 * boxY);

frame = uint8(255 * frame);

end


function [a,b,c] = FindQuadratic(x1, y1, x2, y2, x3, y3)

a = NaN; b = NaN; c = NaN;

xDiff12 = x1 - x2; yDiff12 = y1 - y2;
xDiff13 = x1 - x3; yDiff13 = y1 - y3;

if abs(xDiff12) > 1 && abs(xDiff13) > 1 %Box has moved
    
    a = 1/(x2 - x3) * (yDiff12/xDiff12 - yDiff13/xDiff13);
    b = yDiff13/xDiff13 - a * (x1 + x3);
    c = y3 - a * x3^2 - b * x3;

end

end

function [x1,y1,x2,y2] = ConvertFrames(x1,y1,x2,y2,Xdot,Ydot,dt)

x1 = round(x1 - 2 * Xdot * dt);
y1 = round(y1 - 2 * Ydot * dt);
x2 = round(x2 - 1 * Xdot * dt);
y2 = round(y2 - 1 * Ydot * dt);

end

function [x,y] = FindQuadraticVel(x2, y2, x3, y3, dt)

% x = x3;
% y = y3;

xDiff = (x3 - x2);
yDiff = (y3 - y2);
xAv = (x3 + x2)/2;
yAv = (y3 + y2)/2;


vx = xDiff/dt;
vy = yDiff/dt;

tPlot = ceil(abs(2*yDiff/vy) + abs(2*xDiff/vx));
if isnan(tPlot)
    t = [-10*dt:dt:10*dt];
else
    t = [-tPlot:dt:tPlot];
end


x = x3 + vx * t;
y = y3 + vy * t + 1/2 * 10 * t.^2;
end