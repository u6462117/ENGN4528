close all;
v = VideoReader('../../Angry Birds In-game Trailer.avi');

currAxes = axes;
fontSize = 14;

% numOfFrames = v.NumberOfFrame;

%%%%% -------- Red Bird ---------- %%%%%
% Frame at 15 secs in video (same as (?) Frame 450)
% v.CurrentTime = 15;
% theFrame = readFrame(v);
% figure();
% detectRedBird(theFrame);

%%%%% -------- Blue Bird ---------- %%%%%
v.currentTime = 26;
theFrame = readFrame(v);
figure();
detectBlueBird(theFrame);

%%%%% -------- Yellow Bird ---------- %%%%%
% v.currentTime = 31;
% theFrame = readFrame(v);
% figure();
% detectYellowBird(theFrame);

%%%%% -------- Black Bird ---------- %%%%%
% v.currentTime = 39;
% theFrame = readFrame(v);
% figure();
% detectBlackBird(theFrame);

%%%%% -------- White Bird ---------- %%%%%
% v.currentTime = 42;
% theFrame = readFrame(v);
% detectWhiteBird(theFrame)

%%%%% -------- Green Pigs ---------- %%%%%
theFrame = readFrame(v);
figure();
detectGreenPigs(theFrame);

% R = theFrame(:,:,1);
% B = theFrame(:,:,2);
% G = theFrame(:,:,3);

hThresholds = [0.24, 0.44];
sThresholds = [0.8, 1.0];
vThresholds = [20, 125];

k = 1
while hasFrame(v)
    % Read one frame
    thisFrame=readFrame(v);
    hImage=subplot(3, 4, 1);
    % Display it.
    imshow(thisFrame);
    axis on;
    caption = sprintf('Original RGB, frame #%d', k);
    title(caption, 'FontSize', fontSize);
    drawnow;
    
    hsv = rgb2hsv(double(thisFrame));
    hue=hsv(:,:,1);
    sat=hsv(:,:,2);
    val=hsv(:,:,3);
    
    R = thisFrame(:,:,1);
    B = thisFrame(:,:,2);
    G = thisFrame(:,:,3);
    
    subplot(3, 4, 2);
    imshow(hue, []);
    impixelinfo();
    axis on;
    title('Hue', 'FontSize', fontSize);
    subplot(3, 4, 3);
    imshow(sat, []);
    axis on;
    title('Saturation', 'FontSize', fontSize);
    subplot(3, 4, 4);
    imshow(val, []);
    axis on;
    title('Value', 'FontSize', fontSize);
    
%     subplot(3, 4, 5);
%     imshow(R, []);
%     axis on;
%     title('Red Channel', 'FontSize', fontSize);
%     subplot(3, 4, 6);
%     imshow(G, []);
%     axis on;
%     title('Green Channel', 'FontSize', fontSize);
%     subplot(3, 4, 7);
%     imshow(B, []);
%     axis on;
%     title('Blue Channel', 'FontSize', fontSize);

    if k == 1
        % Enlarge figure to full screen.
        set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
        % Give a name to the title bar.
        set(gcf, 'Name', 'Angry Bird Trailer', 'NumberTitle', 'Off')
        hCheckbox = uicontrol('Style','checkbox',...
            'Units', 'Normalized',...
            'String', 'Finish Now',...
            'Value',0,'Position', [.2 .96 .4 .05], ...
            'FontSize', 14);
    end
    binaryH = hue >= hThresholds(1) & hue <= hThresholds(2);
	binaryS = sat >= sThresholds(1) & sat <= sThresholds(2);
	binaryV = val >= vThresholds(1) & val <= vThresholds(2);
    subplot(3, 4, 5);
	imshow(binaryH, []);
	axis on;
	title('Hue Mask', 'FontSize', fontSize);
	subplot(3, 4, 6);
	imshow(binaryS, []);
	axis on;
	title('Saturation Mask', 'FontSize', fontSize);
	subplot(3, 4, 7);
	imshow(binaryV, []);
	axis on;
	title('Value Mask', 'FontSize', fontSize);
    
    % Overall color mask is the AND of all the masks.
	coloredMask = binaryH & binaryS & binaryV;
	% Filter out small blobs.
	coloredMask = bwareaopen(coloredMask, 500);
	% Fill holes
	coloredMask = imfill(coloredMask, 'holes');
	subplot(3, 4, 9);
	imshow(coloredMask, []);
	axis on;
	title('Colored Blob Mask', 'FontSize', fontSize);
	drawnow;
	
	[labeledImage, numberOfRegions] = bwlabel(coloredMask);
	if numberOfRegions >= 1
		stats = regionprops(labeledImage, 'BoundingBox', 'Centroid');
		% Delete old texts and rectangles
		if exist('hRect', 'var')
			delete(hRect);
		end
		if exist('hText', 'var')
			delete(hText);
		end
		
		% Display the original image again.
		subplot(3, 4, 5); % Switch to original image.
		hImage=subplot(3, 4, 5);
		imshow(thisFrame);
		axis on;
		hold on;
		caption = sprintf('%d blobs found in frame #%d', numberOfRegions, k);
		title(caption, 'FontSize', fontSize);
		drawnow;
		
		%This is a loop to bound the colored objects in a rectangular box.
		for r = 1 : numberOfRegions
			% Find location for this blob.
			thisBB = stats(r).BoundingBox;
			thisCentroid = stats(r).Centroid;
			hRect(r) = rectangle('Position', thisBB, 'EdgeColor', 'r', 'LineWidth', 2);
			hSpot = plot(thisCentroid(1), thisCentroid(2), 'y+', 'MarkerSize', 10, 'LineWidth', 2)
			hText(r) = text(thisBB(1), thisBB(2)-20, strcat('X: ', num2str(round(thisCentroid(1))), '    Y: ', num2str(round(thisCentroid(2)))));
			set(hText(r), 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
		end
		hold off
		drawnow;
    end
    
    k = k+1;
    if get(hCheckbox, 'Value')
        Finish now checkbox is checked.
        msgbox('Done with demo.');
        return;
    end
end
%% Red Bird
% image(theFrame, 'Parent', currAxes);
% slice = theFrame(90:110,60:80,:);
% result = (R>117 & R< 219) .* (G < 89) .* (B > 13 & B < 116);

% Duplicate result Matrix to obtain areas of interest
% M = zeros(size(result));
% M(result == 1) = 1;
% M = M(M(result == 1), :);
% [row,col,v] = find(result);
% detectedPos = [60, 80, 30, 30];
detectedXY = size(M);
detectedPos = [detectedXY, 30, 30];

figure(),imagesc(result);
hold on;
rectangle('Position', detectedPos, 'EdgeColor','r', 'LineWidth', 3);
%
% M = M(90:110,60:80);
% figure(),imagesc(M);
%
% [nRows, nCols] = size(theFrame);

% for rI = 1:nRows
%     for cI = 1:nCols