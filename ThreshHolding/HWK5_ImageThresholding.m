function HWK5_ImageThresholding()
  clc; clear all;
  close all;
  
  % Load image
  I = imread('iceberg.tif');
  figure(1) 
  imshow(I);
  title('original image');
  m = mean(mean(I));
  % Display histogram
  figure(2)
  imhist(I,256);
  title('histogram')
  % Binarize image
  [binImage,k] = my_GrayThresh(I);
  level = graythresh(I);
  BW = imbinarize(I,level);
  % Display binarized image
  figure(3), imshow(binImage);
  title('Binarized image using my Otsu threshold');
  
  figure(4), imshow(BW);
  title('Binarized image using Matlab graythresh');

  % Compare your threshold to MATLAB's threshold
  fprintf('My Otsu threshold %f\n',k);
  % YOU NEED TO COMPLETE FOLLOWING LINE OF CODE
  fprintf('MATLAB Otsu threshold %f\n', level);
end
