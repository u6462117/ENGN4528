clearvars();
close all;

v = VideoReader("Angry Birds In-game Trailer.avi");

frame1_rgb = read(v,440);
frame2_rgb = read(v,445);

[~, frame1] = RemoveBackground(frame1_rgb);
[~, frame2] = RemoveBackground(frame2_rgb);

stitchStruct = StitchThese(frame2, frame1); 

outIm = imwarp(frame1_rgb, stitchStruct.Transformation);
imshow(outIm);

% 
% %% 
% 
% frame1 = rgb2gray(frame1);
% frame2 = rgb2gray(frame2);
% 
% 
% crop_pixels_x = 230; %top 55 pixels contain pause button and menu
% %Below 249 pixels is just ground for red bird scene
% 
% figure();
% imshow(frame1_rgb)
% figure();
% imshow(frame2_rgb)
% 
% 
% frame1_cropped = [zeros(crop_pixels_x,length(frame1)); frame1(230:end,:)];
% frame2_cropped = [zeros(crop_pixels_x,length(frame1)); frame2(230:end,:)]; 
% 
% points1 = detectSURFFeatures(frame1_cropped);
% points2 = detectSURFFeatures(frame2_cropped);
% 
% [features1,valid_points1] = extractFeatures(frame1_cropped,points1);
% [features2,valid_points2] = extractFeatures(frame2_cropped,points2);
% 
% indexPairs = matchFeatures(features1,features2);
% 
% matchedPointsPrev = valid_points1(indexPairs(:,1),:);
% matchedPoints = valid_points2(indexPairs(:,2),:);
% 
% figure; 
% showMatchedFeatures(frame1,frame2,matchedPointsPrev,matchedPoints);
% 
% imageSize = [size(frame1);size(frame2)];
% 
% %% Estimate transform
% tforms(2) = estimateGeometricTransform(matchedPoints, matchedPointsPrev,...
%         'projective', 'Confidence', 99.9, 'MaxNumTrials', 2000);
% tforms(1) = estimateGeometricTransform(matchedPointsPrev, matchedPointsPrev,...
%         'projective', 'Confidence', 99.9, 'MaxNumTrials', 2000);
%     
% % Compute the output limits  for each transform
% for i = 1:numel(tforms)
%     [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(i,2)], [1 imageSize(i,1)]);
% end
% 
% avgXLim = mean(xlim, 2);
% 
% [~, idx] = sort(avgXLim);
% 
% centerIdx = floor((numel(tforms)+1)/2);
% 
% centerImageIdx = idx(centerIdx);
% 
% Tinv = invert(tforms(centerImageIdx));
% 
% for i = 1:numel(tforms)
%     tforms(i).T = tforms(i).T * Tinv.T;
% end
% 
% for i = 1:numel(tforms)
%     [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(i,2)], [1 imageSize(i,1)]);
% end
% 
% maxImageSize = imageSize; %removed max function
% 
% % Find the minimum and maximum output limits
% xMin = min([1; xlim(:)]);
% xMax = max([maxImageSize(2); xlim(:)]);
% 
% yMin = min([1; ylim(:)]);
% yMax = max([maxImageSize(1); ylim(:)]);
% 
% % Width and height of panorama.
% width  = round(xMax - xMin);
% height = round(yMax - yMin);
% 
% % Initialize the "empty" panorama.
% panorama = zeros([height width 3], 'like', frame1);
% 
% blender = vision.AlphaBlender('Operation', 'Binary mask', ...
%     'MaskSource', 'Input port');
% 
% % Create a 2-D spatial reference object defining the size of the panorama.
% xLimits = [xMin xMax];
% yLimits = [yMin yMax];
% panoramaView = imref2d([height width], xLimits, yLimits);
% 
% % Create the panorama.
% for i = 1:2
% 
%     if i==1
%         I = frame1_rgb;
%     elseif i==2
%         I = frame2_rgb;
%     end
% 
%     % Transform I into the panorama.
%     warpedImage = imwarp(I, tforms(i), 'OutputView', panoramaView);
% 
%     % Generate a binary mask.
%     mask = imwarp(true(size(I,1),size(I,2)), tforms(i), 'OutputView', panoramaView);
% 
%     % Overlay the warpedImage onto the panorama.
%     panorama = step(blender, panorama, warpedImage, mask);
% end
% 
% figure
% imshow(panorama)
% 
% % %% Determine average x and y distance between matches
% % feature_locations1 = matched_points1.Location;
% % feature_locations2 = matched_points2.Location;
% % feature_scales1 = matched_points1.Scale;
% % feature_scales2 = matched_points2.Scale;
% % 
% % %remove points related to music symbol in bottom right corner
% % % music symbol located for (x,y) > (435,265)
% % removal_condition = feature_locations1(:,1)>435 & feature_locations1(:,2)>265;
% % 
% % feature_locations1 = feature_locations1(~removal_condition,:);
% % feature_locations2 = feature_locations2(~removal_condition,:);
% % feature_scales1 = feature_scales1(~removal_condition,:);
% % feature_scales2 = feature_scales2(~removal_condition,:);
% % 
% % scale_change = mean(feature_scales1 ./ feature_scales2);
% % 
% % x_change = max(1,round(mean(feature_locations1(:,1)-feature_locations2(:,1))));
% % y_change = max(1,round(mean(feature_locations1(:,2)-feature_locations2(:,2))));
% % %max is used above to ensure we have at least one to avoid indexing issues
% % 
% % 
% % 
% % resized_frame2 = imresize(frame2,1/scale_change);
% % resized_frame2_rgb = imresize(frame2_rgb,1/scale_change);
% % 
% % %initialise panorama
% % panorama = zeros(size(resized_frame2,1)+2*abs(y_change),size(resized_frame2,2)+2*abs(x_change),3); 
% % %add twice the change so we can add either above or below with no indexing
% % %issues
% % 
% % %Add first frame
% % panorama(abs(y_change):abs(y_change)+size(frame1,1)-1,1:size(frame1,2),:) = frame1_rgb;
% % 
% % %overlay second frame
% % panorama(abs(y_change)+y_change:abs(y_change)+y_change+size(resized_frame2,1)-1,abs(x_change):size(resized_frame2,2)+abs(x_change)-1,:) = resized_frame2_rgb;
% % 
% % figure
% % imshow(uint8(panorama));
% % 
% 
