function HWK3_ImageRestoration()
im1 = im2double(imread('Image1_Degraded.tiff'));
im2 = im2double(imread('Image2_Degraded.tiff'));

sigma_b = 5;
filt_size = 2*ceil(3*sigma_b)+1; % filter size
PSF = fspecial('gaussian',filt_size,sigma_b);

nsr1 = get_nsr(im1);
nsr2 = get_nsr(im2);
var1 = var(im1(:));
var2 = var(im2(:));
nsr1 = nsr1/var1;
nsr2 = nsr2/var2;
wnr1 = deconvwnr(im1, PSF, nsr1);
wnr2 = deconvwnr(im2, PSF, nsr2);
figure(1)
subplot(1,2,1);
imshow(im1);
title('original image')
subplot(1,2,2);
imshow(wnr1);
title('image after filtering')
figure(2)
subplot(1,2,1);
imshow(im2);
title('original image')
subplot(1,2,2);
imshow(wnr2);
title('image after filtering')
end

function nsr = get_nsr(inp_img)
N = [1 -2 1; -2 4 -2; 1 -2 1];
[r,c] = size(inp_img);
im_con = conv2(inp_img,N,'same');
im_con = im_con.^2;
nsr = sum(sum(im_con,1),2)/(36*(r-2)*(c-2));

end