function HWK3_SuppressingMoire()
  clc,close all
  
  im = im2double(imread('Moire_Example1.png'));
  % Zero-pad image
  [r,c] = size(im);
  im_pad = padarray(im,[r,c],0,'post');
%   figure
%   imshow(im_pad);
  % Multiply by (-1)^(X+Y) 
  im_center = zeros(2*r,2*c);
  for x = 1:1:2*r
      for y = 1:1:2*c
          im_center(x,y) = im_pad(x,y) * (-1)^(x+y);
      end
  end
  figure()
  imshow(im_center);
  % Compute Fourier Transform
  im_ft = fft2(im_center);
  im_log = log(abs(im_ft));

  
  
  % Find peaks in Fourier domain
  rc_cntr1 = find_nearest_peak(im_log,[r/2,c/2],100);
  rc_cntr1
%   rc_cntr2 = find_nearest_peak(im_log,[r/2,1.5*c],100);
%   rc_cntr2
  rc_cntr2 = find_nearest_peak(im_log,[1.5*r,c/2],100);
  rc_cntr2
%   im_test = im_log(600:1024,1:500);
%   [rp,cp] = find( im_test == max(im_test(:)) )
  
  % Create notch filter centered at each of the peaks
  D = 20;
  H = ones(2*r,2*c);
  for k = 1:2*r
      for l = 1:2*c
        v_k1 = r-rc_cntr1(1); u_k1 = rc_cntr1(2);
        hk = 1-exp(-1/(2*D^2)*((k+v_k1-r)^2+(l+u_k1-c)^2));
        H(k,l) = H(k,l)*hk;
        hk = 1-exp(-1/(2*D^2)*((k-v_k1-r)^2+(l-u_k1-c)^2));
        H(k,l) = H(k,l)*hk;
        
        v_k2 = rc_cntr2(1)-r; u_k2 = rc_cntr2(2);
        hk = 1-exp(-1/(2*D^2)*((k+v_k2-r)^2+(l-u_k2-c)^2));
        H(k,l) = H(k,l)*hk;
        hk = 1-exp(-1/(2*D^2)*((k-v_k2-r)^2+(l+u_k2-c)^2));
        H(k,l) = H(k,l)*hk;
        
      end
  end
  % Display results (original image, filtered image, difference image)
%  H = 1-H;
  G1 = im_ft.*H;
  G = real(ifft2(G1));
  for x = 1:1:2*r
      for y = 1:1:2*c
          G(x,y) = G(x,y) * (-1)^(x+y);
      end
  end
  im_result = G(1:r,1:c);
  figure
  subplot(1,2,1);
  imshow(im_log,[]);
  title('Fourier modulus before filtering')
  subplot(1,2,2);
  imshow(log(abs(G1)),[]);
  title('Fourier modulus after filtering')
  
  figure
  imshow(H,[]);
  title('Notch filter frequency response')

  figure
  im_dif = im-im_result;
  imshow(im_dif,[]);
  title('difference image D=20')
 
  figure
  subplot(1,2,1);
  imshow(im);
  title('original image')
  subplot(1,2,2);
  imshow(im_result)
  title('image after filtering')
  
end

% Find row,column coordinares of nearest intensity peak in image given
% candidate row,column coordinates of the peak
function rc_cntr = find_nearest_peak(inp_img,rc_cntr,HW)
  mask = zeros(size(inp_img));
  r_cntr = rc_cntr(1);
  c_cntr = rc_cntr(2);
  mask(r_cntr-HW:r_cntr+HW,c_cntr-HW:c_cntr+HW) = 1.0;
  inp_img = inp_img .* mask;
  [rp,cp] = find( inp_img == max(inp_img(:)) );
  rc_cntr = [rp,cp];
end