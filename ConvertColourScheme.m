function [convMatrix] = ConvertColourScheme(im)

im = im2double(im);
R = im(:,:,1); G = im(:,:,2); B = im(:,:,3);

lStar = 1/3*(R + G + B);
aStar = R - G;
bStar = 1/2*(R + G) - B;

convMatrix = NaN(5, numel(R));
nRows = size(R,1); nCols = size(R,2);
bigMIdx = 1;

for row = 1:nRows

convMatrix(1, bigMIdx:(bigMIdx+nCols-1)) = lStar(row, :);
convMatrix(2, bigMIdx:(bigMIdx+nCols-1)) = aStar(row, :);
convMatrix(3, bigMIdx:(bigMIdx+nCols-1)) = bStar(row, :);
convMatrix(4, bigMIdx:(bigMIdx+nCols-1)) = (1:nCols)/nCols;
convMatrix(5, bigMIdx:(bigMIdx+nCols-1)) = row/nRows;

bigMIdx = bigMIdx + nCols;
end

end
