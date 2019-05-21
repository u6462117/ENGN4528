function [panorama] = StitchFromFrames(frame1_rgb, frame2_rgb)
% persistent v;
% 
% if isempty(v)
%     v = VideoReader("Angry Birds In-game Trailer.avi");
% end

try
    

%     v.currentTime = t1;
%     frame1_rgb = readFrame(v);
%     
%     v.currentTime = t2;
%     frame2_rgb = readFrame(v);
    
    [~, frame1] = RemoveBackground(frame1_rgb);
    [~, frame2] = RemoveBackground(frame2_rgb);
    
    stitchStruct = FindCorrespondences(frame2, frame1);
    
    tforms = [affine2d, stitchStruct.Transformation];
    
    imageSize = [320, 480];
    %maxImageSize = imageSize;
    
    xMin = 1; xMax = 480;
    yMin = 1; yMax = 320;
    
    width  = round(xMax - xMin);
    height = round(yMax - yMin);
    
    % Initialize the "empty" panorama.
    panorama = zeros([height width 3], 'like', frame1);
    
    xLimits = [xMin xMax];
    yLimits = [yMin yMax];
    panoramaView = imref2d([height width], xLimits, yLimits);
    
    
    
    blender = vision.AlphaBlender('Operation', 'Binary mask', ...
        'MaskSource', 'Input port');
    
    
    p1 = stitchStruct.FixedMatchedFeatures.Location;
    p2 = stitchStruct.MovingMatchedFeatures.Location;
    
    figure('Visible', 'off');
    showMatchedFeatures(frame1_rgb,frame2_rgb,p2,p1);
    export_fig(['figs/', num2str(t1), '_', num2str(t2), '_match',], gcf);
    
    for i = 1:2
        
        if i==1
            I = frame1_rgb;
        elseif i==2
            I = frame2_rgb;
        end
        
        % Transform I into the panorama.
        warpedImage = imwarp(I, tforms(i), 'OutputView', panoramaView);
        
        % Generate a binary mask.
        mask = imwarp(true(size(I,1),size(I,2)), tforms(i), 'OutputView', panoramaView);
        
        % Overlay the warpedImage onto the panorama.
        panorama = step(blender, panorama, warpedImage, mask);
    end
    
%     figure('Visible', 'off');
%     imshow(panorama)
%     export_fig(['figs/', num2str(t1), '_', num2str(t2), '_pano',], gcf);

catch
    
end

end



