function [binImage,kopt] = my_GrayThresh( inp_GrayImage )
  % Your implementation goes here
  inp_GrayImage = imread('iceberg.tif');
  I = inp_GrayImage;
  I = im2uint8(I(:));
  % Get histogram. hist(i) is the count of pixels with value x(i).
  h = imhist(I,256);
  p = h/sum(h);
  omega = cumsum(p);
  mu = cumsum(p.*(1:256)');
  mg = mu(end);
  % Convert to probability
  sigmaSquared = (mg * omega - mu).^2 ./ (omega .* (1 - omega));
  % Search for threshold k
  
  % Maximize the between class variance
  maxSig = max(sigmaSquared);
  kopt = mean(find(sigmaSquared == maxSig));
  kopt = (kopt-1)/(numel(p) - 1);
  % Threshold image
  binImage = imbinarize(inp_GrayImage, kopt);
end