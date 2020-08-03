function HWK4_Diffusion()
  clc,close all
  
% Step-1: Read images
% ~~~~~~~~~~~~~~~~~~~  
%   I0 = im2double(imread('cameraman.tif'));
  %I0 = im2double(rgb2gray(imread('coloredChips.png')));

  % Replace with 2 images of your choice
  % I0 = im2double(rgb2gray(imread('starry-night-reference.jpg')));
  I0 = im2double(rgb2gray(imread('einstein.bmp')));
  % Explain why you picked these images
  
% Step-2: Diffusion
% ~~~~~~~~~~~~~~~~~
  % Setup diffusion parameters
  dt = 0.1;
  L = 8;
  Tpoll = (2.^(0:2:L-1)) * dt;  % Example
  Tend = Tpoll(end);            % Example
  
  % Implement diffusion  
  % Isotropic diffusion  
%   [I,It] = IsotropicDiffusion( I0,dt,Tend,Tpoll );  
  % Perona-Malik diffusion
  
   K = 1; % You need to pick this value
   [I,It] = PMDiffusion( I0,dt,Tend,Tpoll,K );  

% Step-3: Compute edge maps of each image in It
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% NEEDS TO BE COMPLETED

% Step-4: Display
% ~~~~~~~~~~~~~~~
  % Display original image
  figure
    imshow( I0,[],'InitialMagnification','fit' );
    title('Original Image');
  
  figure
    [du,~] = imgradient(I0,'central');
    hist(du);
   title('Gradient Magnitude histogram of Cameranman');
  % Display filtered image
  figure
    imshow( I,[],'InitialMagnification','fit' );
    title(sprintf('Final Image at time t=%f',Tend));

  % Display all intermediate images
  figure(101)
    set(gcf,'units','normalized','outerposition',[0 0 1 1]); % full-screen
    % Single title
    title('Result of filtering by diffusion'); % Only in MATLAB R2018b
  figure(201)
    set(gcf,'units','normalized','outerposition',[0 0 1 1]); % full-screen
    % Single title
    title('Edge maps of filtered images'); % Only in MATLAB R2018b
  %
  numT = numel(Tpoll);
  for nitr = 1:numT
    % Display intermediate images at different times 
    figure(101)
      subplot(1,numT,nitr);
      imshow( It(:,:,nitr),[],'InitialMagnification','fit' );
      title(sprintf('t=%f',Tpoll(nitr)),'FontName','Courier New','FontSize',8);      
    
    % Display edge images at different times
    % NOTE: Code is incomplete
    Ie = edge(It(:,:,nitr),'canny');
    figure(201)
      subplot(1,numT,nitr);
      imshow( Ie,[],'InitialMagnification','fit' );
      title(sprintf('t=%f',Tpoll(nitr)),'FontName','Courier New','FontSize',8);      
  end
end