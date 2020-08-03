function [houghSpace,a,b] = houghTransform_for_Circles(im,radius)
  %Define the hough space
  [nR,nC] = size(im);
  
  if nargin < 2
    error('ERROR: Need to provide radius.');
  else
    assert( radius < norm([nR,nC])/2,'ERROR: ' );
  end

  % The Hough Accumulator array for circles is parametrized by two
  % quantities: the center of each circle
  % The candidate centers could be anywhere in the image
  % Thus, the houghSpace must have size nR x nC
  
  %Find the "edge" pixels
  [r,c] = find(im == 1);
  % Define Hough Parameter Space
  houghSpace = zeros(nR, nC, 1);

  % Angle parameter Used to create circles
  theta = 0:360;
  % Accumlate Hough votes
  for i = 1:size(r)
      for k = 1:length(theta)
          a = round(r(i)+radius*cos(theta(k)));
          b = round(c(i)-radius*sin(theta(k)));
          if(a>0&a<=nR&b>0&b<=nC)
          houghSpace(a,b,1) = houghSpace(a,b,1) + 1;
          end
      end
  end

  % The boundary of the Hough space contains strong and spurious peaks
  % Null them out to avoid confusion
%   filter = fspecial('Gaussian',[2 1], 1);% for runway.jpg
%   houghSpace = round(imfilter( houghSpace, filter,'conv' ));
  
end