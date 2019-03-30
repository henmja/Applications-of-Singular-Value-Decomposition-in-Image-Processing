clear;close all;clc

img = imread('images/max_original.jpg');
doubleImg = double(img);
figure(1);
imshow(img)
title('Original Image')
 
rankings = [10,20,30,40,50];
for i= 1:length(rankings)
    %Convert all the rows and columns in the first colour plane in 
    %img_gray from intensity to double
    red = doubleImg(:,:,1);
    %Convert all the rows and columns in the second colour plane in 
    %img_gray from intensity to double
    green = doubleImg(:,:,2);
    %Convert all the rows and columns in the third colour plane in 
    %img_gray from intensity to double
    blue = doubleImg(:,:,3);
 
    [U,S,V] = svds(red,rankings(i));
    compressedRed = U*S*V';
    [U,S,V] = svds(green,rankings(i));
    compressedGreen = U*S*V';
    [U,S,V] = svds(blue,rankings(i));
    compressedBlue = U*S*V';
 
    CompressedImg(:,:,1) = compressedRed; %Red = first image plane
    CompressedImg(:,:,2) = compressedGreen; %Green = second image plane
    CompressedImg(:,:,3) = compressedBlue; %Blue = third image plane
 
    figure(i+1);
    imshow(uint8(CompressedImg))
    header=(['Rank: ',num2str(rankings(i))]);
    title(header)
end

