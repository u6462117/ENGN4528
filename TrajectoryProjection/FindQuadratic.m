function [trajX, trajY] = FindQuadratic(bird, T)

dt = 0.1;

birdX2 = bird(1) + bird(3)/2;
birdY2 = bird(2) + bird(4)/2;

sx = T(1,1);
sy = T(2,2);
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

function [x,y] = FindTimeSeries(x2, y2, x3, y3, dt)


xDiff = (x3 - x2);
yDiff = (y3 - y2);
% xAv = (x3 + x2)/2;
% yAv = (y3 + y2)/2;


vx = xDiff/dt;
vy = yDiff/dt;

tPlot = ceil(abs(2*yDiff/vy) + abs(2*xDiff/vx));
if isnan(tPlot)
    t = [0:dt:100*dt];
else
    t = [-5*tPlot:dt:0];
end


x = x3 + vx * t;
y = y3 + vy * t + 1/2 * 10 * t.^2;
end