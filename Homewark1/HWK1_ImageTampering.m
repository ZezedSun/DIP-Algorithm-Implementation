function HWK1_ImageTampering()
% Starter Code supplied with Homework-1
% This code is incomplete.

  clc,close all
  
% Original image
  im_original = rgb2gray(imread('starry-night-reference.jpg'));
  im_originaldb = im2double(rgb2gray(imread('starry-night-reference.jpg')));
% Tampered image
  im_tampered = generate_tampered_image(im_original);
  im_tampereddb = generate_tampered_image(im_originaldb);
  
  
% Generate difference image
    % without typecasting
  im_difference = abs(im_tampered - im_original);
    % with typecasting
  im_differencedb = abs(im_tampereddb - im_originaldb);
  
% Display results to detect evidence of tampering
  figure
    imshow( im_original,[] );
    title('Original Image')
  figure
    imshow( im_tampered,[] );
    title('Tampered Image')
  figure
    imshow( im_difference,[]);
    title('Difference Image')
  figure
    imshow( im_differencedb,[]);
    title('Difference Image with typecasting')
end

