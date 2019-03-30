clear;close all;clc;

img = imread('images/max_original.jpg');
doubleImg = double(img);
figure(1);
imshow(img)
title('Original Image')
img_gray = rgb2gray(doubleImg);
 
rankings = [10,20,30,40,50];
for i= 1:length(rankings)
    [U,S,V] = svds(img_gray,rankings(i));
    SVD = U*S*V';
 
    figure(i+1);
    imshow(uint8(SVD))
    header=(['Rank: ',num2str(rankings(i))]);
    title(header)
end

