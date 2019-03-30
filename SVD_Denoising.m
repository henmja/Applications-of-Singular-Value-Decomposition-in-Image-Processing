clear;close all;clc;

figure(1);
img = (imread('images/max_original.jpg'));
imshow(img);
title('Original Image');

img = im2double(img);
imgGray = rgb2gray(img); 
figure(2);
imshow(imgGray);
title('Grayscale Image');

figure(3);
%Add 'salt%pepper' noise to grayscale image:
imgNoise = imnoise(imgGray, 'salt & pepper');
imshow(imgNoise);
title('Grayscale Image with "Salt&Pepper" Noise');

%Patch Grouping:
[rows, columns] = size(imgNoise); 
nPatches = 5; %number of patches/singular values
patch = zeros(nPatches^2,rows/nPatches,columns/nPatches);
numRows = size(patch,2);
numCols = size(patch,3);

idx = 1;
for i = 0:nPatches-1
    for j = 0:nPatches-1
        for k = 1:size(patch,2)
            for l = 1:size(patch,3)
                patch(idx,k,l) = imgNoise(i *numRows + k , j*numCols + l);
                imgVals(k,l) = imgNoise(i *numRows + k , j*numCols + l);
            end
        end
        idx = idx + 1;
    end
end



% ------ SVD on each patch

%images are usually not symmetric, therefore, calculate SVD for img x img 
%transposed
symmetricImg = imgNoise'*imgNoise;
[V,eigVals] = eig(symmetricImg); 
S = sqrt(eigVals); 
Vimg = imgNoise*V; 
U = zeros(rows,columns);
for i = 1:columns
    U(:,i) = Vimg(:,i)/S(i,i);
end

denoisedImg = zeros(size(patch));
%Number of singular values for each of the patches:
nRanks = 10;

for i = 1:nPatches*nPatches
    for j = 1:numRows
        for k = 1:numCols
            imgVals(j,k) = patch(i,j,k);
        end
    end
    symmetricImg = imgVals' * imgVals ;
    [V,eigVals] = eig(symmetricImg); 
    U = zeros(numRows,numCols);
    S = sqrt(eigVals); 
    Vimg = imgVals * V; 
    for j = 1:numCols
        U(:,j) = Vimg(:,j)/S(j,j);
    end
    prunedS = zeros(numCols,numCols);
    for j=size(S,2)-nRanks:size(S,2)
        prunedS(j,j) = S(j,j);
    end
    denoisedImg(i,:,:) = U*prunedS*255*V'; %SVD (U*S*V^T)/denoised image
end

idx = 1;
aggImg = zeros(numRows*(nPatches-1)+numRows, numCols*(nPatches-1)+numCols);
for i = 0:nPatches-1
    for j = 0:nPatches-1
        for k = 1:numRows
            for l = 1:numCols
                %Aggregation: Im_rec aggregated denoised image.
                imgVals(k,l) = denoisedImg(idx,k,l);
                aggImg(numRows*i+k, j*numCols+l) = denoisedImg(idx,k,l);
            end
        end
        idx = idx + 1;
    end
end

figure(4); 
imshow(aggImg, []);
title('Aggregated Denoised Image')