close all;
clearvars();

v = VideoReader("Angry Birds In-game Trailer.avi");

time = 0;
dt = 0.1;
slingshotTimeout = 7;
slingshotDetectTime = -9999;


slingshotFoundTimes = [];
slingshotFoundFrames = cell(3,0);

while time <= 66.6122
    
    %% Setup
    currFrame = readFrame(v);
    
    %% Mode Identifiaction
    if (time - slingshotDetectTime) > slingshotTimeout
        
        %Detect slingshot
        [slingshotFound, slingshotLoc] = detectSlingshot2(currFrame);
        
        if slingshotFound
            slingshotDetectTime = time;
            slingshotFoundTimes = [slingshotFoundTimes, time];
            idx = size(slingshotFoundFrames,2);
            location = slingshotLoc{1};
            assert(size(slingshotLoc,2) < 2)
            slingshotFoundFrames{1,idx+1} = location;
            slingshotFoundFrames{2,idx+1} = currFrame;
            rec = location;
            try
                watchBoxNow = ...
                currFrame( rec(2)-65:rec(2) -20,rec(1) + rec(3) :rec(1) + rec(3) + 75,:);
                slingshotFoundFrames{3,idx+1} = watchBoxNow;
            catch
                watchBoxNow = ...
                currFrame( rec(2)-65:rec(2) -20,rec(1) + rec(3) :end,:);
                slingshotFoundFrames{3,idx+1} = watchBoxNow;  
            end
            
        end
        
    end
    
    time = time + dt;
    if time < 66.6122
        v.CurrentTime = time;
    end
end

for i = 1:length(slingshotFoundTimes)
    figure();
    title(num2str(slingshotFoundTimes(i)));
    rec = slingshotFoundFrames{2,i};
    imshow(rec);
    
    hold on;
    rectangle('Position', slingshotFoundFrames{1,i},'EdgeColor','magenta', 'LineWidth',2);
    
%     try
%         offsetRec = [rec(1) + rec(3), rec(2)-65, 75, 45];
%         rectangle('Position', offsetRec);
%     catch
%         offsetRec = [rec(1) + rec(3), rec(2)-65, 75, 480 - (rec(1) + rec(3)) - 1];
%         rectangle('Position', offsetRec);
%     end
    
end
