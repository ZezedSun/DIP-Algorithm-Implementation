function HistogramEqualization_Part1()
im = imread('Dark_Road.jpg');
figure(1)
imhist(im);
im_j = histeq(im);
figure(2)
imshowpair(im,im_j,'montage')
axis off
figure(3)
imhist(im_j);


end