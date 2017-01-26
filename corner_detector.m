% img is an image
% cimg is a corner matrix

function [cimg] = corner_detector(img)
I=rgb2gray(img);
cimg = cornermetric(I,'MinimumEigenvalue');
figure;
imshow(imadjust(cimg));
end