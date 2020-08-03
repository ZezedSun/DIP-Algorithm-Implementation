function [outpImg,outpImg_glpf] = bilateral_filter(inpImg, sigma_r, sigma_s)
outpImg_glpf = gray_gaussian_filter(inpImg,sigma_s);
outpImg = bilat_filter(inpImg,sigma_r,sigma_s);
end


function [outpImg_glpf] = gray_gaussian_filter(image,sigma_s) 
h = gaussian_filter(sigma_s);
r = ceil(3*sigma_s);
s = size(image);
im_temp = zeros(s);
im2 = padarray(image,[r,r],'replicate','both');
for i = r+1:s(1)+r
    for j = r+1:s(2)+r
        temp = im2(i-r:i+r,j-r:j+r);
        temp = rot90(temp,2);
        temp1 = temp.*h;
        im_temp(i-r,j-r) = sum(temp1(:));
    end
end
outpImg_glpf = im_temp;
end

function [im_bilatfilt] = bilat_filter(image,sigma_r,sigma_s)
 filt_size = 2*ceil(3*sigma_s)+1; % filter size
 r   = ceil(3*sigma_s);
 [x,y] = meshgrid(-r:r,-r:r);
 arg = -(x.*x + y.*y)/(2*sigma_s*sigma_s);
 h_g = exp(arg);
%  h_g = cast(h_g,'double');
 s = size(image(:,:,1));
 im_temp_L = image(:,:,1);    % get L level
 im_temp_a = image(:,:,2);
 im_temp_b = image(:,:,3);
 im_temp_L = padarray(im_temp_L,[r,r],'replicate','both'); % prepad
 im_temp_a = padarray(im_temp_a,[r,r],'replicate','both');
 im_temp_b = padarray(im_temp_b,[r,r],'replicate','both');
 im_final = zeros(size(image));
 for i = r+1:s(1)+r
    for j = r+1:s(2)+r
        Iq_L = im_temp_L(i-r:i+r,j-r:j+r);
        Iq_a = im_temp_a(i-r:i+r,j-r:j+r);
        Iq_b = im_temp_b(i-r:i+r,j-r:j+r);
        Gr_L = abs(Iq_L-image(i-r,j-r,1)); 
        Gr_a = abs(Iq_a-image(i-r,j-r,2));
        Gr_b = abs(Iq_b-image(i-r,j-r,3));
        h_i = exp(-(Gr_L.^2+Gr_a.^2+Gr_b.^2)/(2*sigma_r*sigma_r));
        W = h_g.*h_i;
%         Ip_L = W.*image(i-r,j-r,1);
%         Ip_a = W.*image(i-r,j-r,2);
%         Ip_b = W.*image(i-r,j-r,3);
        Ip_L = W.*Iq_L;
        Ip_a = W.*Iq_a;
        Ip_b = W.*Iq_b;
        im_final(i-r,j-r,1) = sum(Ip_L(:))/sum(W(:));
        im_final(i-r,j-r,2) = sum(Ip_a(:))/sum(W(:));
        im_final(i-r,j-r,3) = sum(Ip_b(:))/sum(W(:));
    end
 end
 im_bilatfilt = im_final;
end

function [im_gaussian] = gaussian_filter(sigma_s)
filt_size = 2*ceil(3*sigma_s)+1; % filter size
p = [filt_size,filt_size];
siz   = (p-1)/2;
[x,y] = meshgrid(-siz(2):siz(2),-siz(1):siz(1));
arg = -(x.*x + y.*y)/(2*sigma_s*sigma_s);
h_gaussian = exp(arg)/(2*pi*sigma_s*sigma_s);
im_gaussian = cast(h_gaussian,'double');

end
 

