close all;
clearvars();

time = 15;

while time < 60
    
    StitchFromTime(time, time + 0.5)
    time = time + 1;
    
end

