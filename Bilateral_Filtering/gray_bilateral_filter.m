function [outpImg,outpImg_glpf] = gray_bilateral_filter(inpImg, sigma_r, sigma_s)
outpImg_glpf = gray_gaussian_filter(inpImg,sigma_s);
outpImg = bilat_filter(inpImg,sigma_r,sigma_s);
end

function [outpImg_glpf] = gray_gaussian_filter(image,sigma_s) 
h = gaussian_filter(sigma_s); % use gaussian_filter function
r = ceil(3*sigma_s);          % identify r = (filter size -1)/2
s = size(image);              
im_temp = zeros(s);           % prepare the matrix for store
im2 = padarray(image,[r,r],'replicate','both'); % prepad image boundry
for i = r+1:s(1)+r
    for j = r+1:s(2)+r
        temp = im2(i-r:i+r,j-r:j+r);  % get the window to be filter
        temp = rot90(temp,2);         % rotate 180 degree for convolution
        temp1 = temp.*h;              % convolution
        im_temp(i-r,j-r) = sum(temp1(:)); % store the value to target matrix
    end
end
outpImg_glpf = im_temp;
end

function [im_bilatfilt] = bilat_filter(image,sigma_r,sigma_s)
 filt_size = 2*ceil(3*sigma_s)+1; % filter size
 r = ceil(3*sigma_s);             % identify r is half of filter size 
 [x,y] = meshgrid(-r:r,-r:r);     % produce grids for gaussian filter
 arg = -(x.*x + y.*y)/(2*sigma_s*sigma_s);% gaussian
 h_g = exp(arg);                          % filter
 s = size(image);
 im_temp = padarray(image,[r,r],'replicate','both'); % prepad image boundry by replicate
 im_final = zeros(size(s));               % prepare
 for i = r+1:s(1)+r
    for j = r+1:s(2)+r
        Iq = im_temp(i-r:i+r,j-r:j+r);    % intensity of pixel
        Gr = abs(Iq-image(i-r,j-r));      % calculate the intensity difference 
        h_i = exp(-Gr*Gr/(2*sigma_r*sigma_r)); % gaussian filter kernel
        W = h_g.*h_i;              % mutiply the spacial and intensity gaussian kernel
        Ip = Iq.*W;                % mutiply the weight with intensity of pixel
        im_final(i-r,j-r) = sum(Ip(:))/sum(W(:)); % normalization
    end
 end
 im_bilatfilt = im_final;
end

function [im_gaussian] = gaussian_filter(sigma_s)
filt_size = 2*ceil(3*sigma_s)+1; % filter size
siz   = ceil(3*sigma_s);         
[x,y] = meshgrid(-siz:siz,-siz:siz);
arg = -(x.*x + y.*y)/(2*sigma_s*sigma_s);
h_gaussian = exp(arg)/(2*pi*sigma_s*sigma_s);
im_gaussian = cast(h_gaussian,'double');
 end

