function HWK2_GrayScaleDenoising_using_BLFilter()
  clc,close all
  
% GrayScale image Bilateral filtering 
  im_noisy = im2double(imread('NoisyGrayImage.png'));

% Identify a patch that has uniform intensity
% Use the intensity variance of this patch to identify sigma_r
  sigma_s = 7; % You need to supply this value
  sigma_r = 0.5; % You need to supply this value

  [im_blf,im_glpf] = gray_bilateral_filter(im_noisy,sigma_r,sigma_s);
%   im_blf_MATLAB = imbilatfilt(im_noisy,sigma_r,sigma_s);
%   im_blf_diff = abs(im_blf - im_blf_MATLAB);
%   h = fspecial('gaussian',(sigma_s-1)/2,sigma_s);
%   im_glpf_MATLAB = imfilter(im_noisy,h,'replicate');
%   im_glpf_diff = abs(im_glpf - im_glpf_MATLAB);
  
  figure(1)
  imshowpair(im_noisy,im_blf,'montage');
  title('original image and denoised result using Bilateral filtering');
  figure(2)
  imshowpair(im_noisy,im_glpf,'montage');
  title('original image and denoised result using Gaussian filtering');
  
%   figure(3)
%   imshow(im_blf_diff,[],'InitialMagnification','fit');
%   title('Difference between my implementation & MATLAB');
%   
%   figure(4)
%   imshow(im_glpf_diff,[],'InitialMagnification','fit');
%   title('Difference between my implementation & MATLAB');

% Display the noisy image, the result of bilateral filtering
% Use MATLAB's imshow() to display the image
% Use MATLAB's subplot() function if necessary
%
% Example: imshow(im_noisy,[],'InitialMagnification','fit');

end