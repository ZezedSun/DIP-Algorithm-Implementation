function HWK2_ImageEnhancement_using_CrossBLFilter()
  clc,close all
  
% Load images  
% -------------------
% No Flash image
  imRGB_noisy = im2double(imread('NoFlash.png'));
  imLAB_noisy = rgb2lab(imRGB_noisy);
  
% Flash image
  imRGB_guide = im2double(imread('WithFlash.png'));
  imLAB_guide = rgb2lab(imRGB_guide);
  
% Identify patch variance
% -------------------------------
% Find a patch in the image with near constant intensity
% Use the variance of this patch to identify sigma_r
  patch = imcrop(imLAB_guide,[1,1,50,50]);
  patchSq = patch.^2;
  edist = sqrt(sum(patchSq,3));
  patchStd = std2(edist);
  patchVar = patchStd.^2;
% Denoise NoFlash image using Flash image and Cross Bilateral Filtering
  sigma_s = 3;   % Spatial sigma - You need to supply this value
  sigma_r = patchVar;   % Intensity sigma - You need to supply this value
  
  imLAB_denoise = joint_bilateral_filter(imLAB_noisy,imLAB_guide,sigma_r,sigma_s);
  imRGB_denoise = lab2rgb(imLAB_denoise);
    
% Display outputs - No-flash image, Flash image, Result of Joint Bilateral
  figure(1)
    subplot(131),
    imshow(imRGB_noisy,[],'InitialMagnification','fit');
    title('No-flash Image');
    %
    subplot(132),imshow(imRGB_guide,[],'InitialMagnification','fit');
    title('Flash Image');
    %
    subplot(133),imshow(imRGB_denoise,[],'InitialMagnification','fit'); 
    title('Result of Joint Bilateral');
  
% filtering


% Extract detail from Flash image using Bilateral Filtering
  sigma_s = 11;   % Spatial sigma - You need to supply this value
  sigma_r = patchVar;   % Intensity sigma - You need to supply this value
  
  [imLAB_blf,~] = bilateral_filter(imLAB_guide,sigma_r,sigma_s);
  imRGB_blf = lab2rgb(imLAB_blf);
  
  %Detail component
  imRGB_detail = (imRGB_guide+0.01)./(imRGB_blf+0.01);
  
% Display outputs - Flash image, Result of Bilateral filtering, Detail
% component
  figure(2)
    subplot(131),
    imshow(imRGB_guide,[],'InitialMagnification','fit');
    title('Flash Image');
    %
    subplot(132),imshow(imRGB_blf,[],'InitialMagnification','fit');
    title('Result of Bilat-filtering');
    %
    subplot(133),imshow(imRGB_detail,[],'InitialMagnification','fit'); 
    title('Detail component');
   
% Final result of enhancement  
  imRGB_composite = imRGB_denoise .* imRGB_detail;

% Display outputs - No Flash image, Flash image, Enhanced image  
  figure(3)
    subplot(131),
    imshow(imRGB_noisy,[],'InitialMagnification','fit');
    title('No-flash Image');
    %
    subplot(132),imshow(imRGB_guide,[],'InitialMagnification','fit');
    title('Flash Image');
    %
    subplot(133),imshow(imRGB_composite,[],'InitialMagnification','fit'); 
    title('Result of Enhenced image');
   
end