function HistogramEqualization_Part2()
clc,clear all
im = imread('CheckerBoard.png');
figure(1)
imhist(im);
im_j = histeq(im);
figure(2)
imshow(im_j);
figure(3)
imhist(im_j);



end