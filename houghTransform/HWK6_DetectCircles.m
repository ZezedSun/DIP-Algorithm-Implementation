function HWK6_DetectCircles()
  clc, close all
  clear all

  numCircles = 26;  % Number of circles we want to detect
  radius = 23;    % Radius of circles you are trying to detect 

  %% STEP 1. Select image
  im_rgb = im2double(imread('coloredChips.png'));
  if size(im_rgb,3) > 1 % If color convert to grayscale
    im_gray = im2double(rgb2gray(im_rgb));
  end
  % Display original image
    figure(1)
    imshow(im_rgb);
    title('Original Image');
  %% STEP 2. Threshold gradient or use Canny edge detector
  im_binary = edge(im_gray,'Canny',[0.1 0.4]);
  % Display edge image
  figure(2)
   imshow(im_binary);
   title('Output of Canny Edge Detector');
  %% STEP 3. Build Hough Accumulator
  % WARNING: You need to complete this code
  [HS,a,b] = houghTransform_for_Circles(im_binary, radius);
    
  %% STEP 4. Detect local maxima in Hough Space
  % Use built-in function provided by MATLAB
  % does non-maximum suppression for you
  % Pick different thresholds...What do you see?
  P  = houghpeaks(HS,numCircles,'Threshold',0);  
  centers = [ P(:,2) , P(:,1) ]; % X,Y coordinates of circle centers
 
  % Display hough space image & overlay peaks
  figure(3)
  imshow(HS,[],'InitialMagnification','fit');
%   xlabel('\b'), ylabel('\a');
  axis on, axis normal, hold on
  plot(P(:,2),P(:,1),'s','color','white');
   brighten(gcf,0.2);
  colormap copper
  title('Hough Space Diagram with r = 23','fontsize',12,'fontname','Courier New');
  
  
  %% STEP 5. Draw circles associated with peaks in Hough Space
    figure(4)
    imshow(im_gray,[],'initialMagnification','fit');
    axis on, hold on
    for j = 1:length(centers)     
        viscircles(centers(j,:), radius, 'Color', 'b');
    end
    title('Circles assiciated with peaks in Hough Space ');
  %% STEP 6. Find yellow circles
    figure(5)
    imshow(im_rgb,[],'initialMagnification','fit');
    axis on, hold on
    for j = 1:length(centers)
        red = im_rgb(P(j,1),P(j,2),1);
        green = im_rgb(P(j,1),P(j,2),2);
        blue = im_rgb(P(j,1),P(j,2),3);
        if (red>0.7 & green>0.7 & blue<0.2)
            viscircles(centers(j,:), radius, 'Color', 'b');
        end
    end
    title('Only detect the yellow chips');
end