function Denoising_by_Averaging()
clc,close all
im = imread('sombrero-galaxy-original.tif');
im_original = im2double(imread('sombrero-galaxy-original.tif'));
sigma = 16/256;
L = 50;
im_output = im_original;
output_noise = 0;
for i=1:L
    noise = randn(size(im_original)).*sigma;
    output_noise = output_noise + noise;
end
output_noise = output_noise/L;
im_noise = im_output + output_noise;
im_noise = max(min(im_noise,255),0);
figure(1)
imshow(im_original);
title('original images')
figure(2)
imshow(im_noise);
title('averaging 50 noisy images')
err = im_original - im_noise;
mse = mean(err(:).^2)
end
