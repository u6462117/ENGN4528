function [trajX, trajY] = FindQuadratic(bird, T, dt)

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

% birdX1 = birdX2 - 5;
% birdY1 = birdY2 + 5;

[trajX, trajY] = FindTimeSeries(birdX1, birdY1,...
                                    birdX2, birdY2,...
                                    dt);


end

function [x,y] = ConvertFrames(x, y, tx, ty, sx, sy)


x = 1/sx * (x - tx);
y = 1/sy * (y - ty);

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