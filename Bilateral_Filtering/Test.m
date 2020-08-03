  clc,clear all;

  imRGB_noisy = im2double(imread('NoFlash.png'));
  imLAB_noisy = rgb2lab(imRGB_noisy);
  
% Flash image
  imRGB_guide = im2double(imread('WithFlash.png'));
  imLAB_guide = rgb2lab(imRGB_guide);
  
  image_guide = imLAB_guide;
  image_noisy = imLAB_noisy;
  
  patch = imcrop(imLAB_guide,[1,1,50,50]);
  patchSq = patch.^2;
  edist = sqrt(sum(patchSq,3));
  patchStd = std2(edist);
   patchVar = patchStd.^2;

% Attempt Bilateral Filtering using your implementation
  sigma_s = 0.5;                % Spatial sigma - You need to supply this value
  sigma_r = 4*patchVar;       % Intensity sigma - You need to supply this value
  
 r = ceil(3*sigma_s);
 [x,y] = meshgrid(-r:r,-r:r);
 arg = -(x.*x + y.*y)/(2*sigma_s*sigma_s);
 h_g = exp(arg);
 h_g = cast(h_g,'double');
 s = size(image_noisy(:,:,1));
 im_temp_noisy = padarray(image_noisy,[r,r],'replicate','both');
 im_temp_guide = padarray(image_guide,[r,r],'replicate','both');
 im_final = zeros(size(image_noisy));
 for i = r+1:s(1)+r
    for j = r+1:s(2)+r
        %get k_p of imLAB_noisy
        Iq_noisy_L = im_temp_noisy(i-r:i+r,j-r:j+r,1);
        Iq_noisy_a = im_temp_noisy(i-r:i+r,j-r:j+r,2);
        Iq_noisy_b = im_temp_noisy(i-r:i+r,j-r:j+r,3);
        Gr_noisy_L = abs(Iq_noisy_L-image_noisy(i-r,j-r,1)); 
        Gr_noisy_a = abs(Iq_noisy_a-image_noisy(i-r,j-r,2));
        Gr_noisy_b = abs(Iq_noisy_b-image_noisy(i-r,j-r,3));
        h_i_noisy = exp(-(Gr_noisy_L.^2+Gr_noisy_a.^2+Gr_noisy_b.^2)/(2*sigma_r*sigma_r));
        W_noisy = h_g.*h_i_noisy;
        k_p = sum(W_noisy(:));
        
        %get W of imLAB_guide
        Iq_guide_L = im_temp_guide(i-r:i+r,j-r:j+r,1);
        Iq_guide_a = im_temp_guide(i-r:i+r,j-r:j+r,2);
        Iq_guide_b = im_temp_guide(i-r:i+r,j-r:j+r,3);
        Gr_guide_L = abs(Iq_guide_L-image_guide(i-r,j-r,1)); 
        Gr_guide_a = abs(Iq_guide_a-image_guide(i-r,j-r,2));
        Gr_guide_b = abs(Iq_guide_b-image_guide(i-r,j-r,3));
        h_i_guide = exp(-(Gr_guide_L.^2+Gr_guide_a.^2+Gr_guide_b.^2)/(2*sigma_r*sigma_r));
        W_guide = h_g.*h_i_guide;
        
        %get W_F*Iq_A
        Ip_L = Iq_noisy_L.*W_guide;
        Ip_a = Iq_noisy_a.*W_guide;
        Ip_b = Iq_noisy_b.*W_guide;
        
        %get sum(Ip)/k_p
        im_final(i-r,j-r,1) = sum(Ip_L(:))/k_p;
        im_final(i-r,j-r,2) = sum(Ip_a(:))/k_p;
        im_final(i-r,j-r,3) = sum(Ip_b(:))/k_p;
    end
 end
 
 imRGB_denoise = lab2rgb(im_final);
 
 figure(1)
 imshow(imRGB_denoise);
 
 