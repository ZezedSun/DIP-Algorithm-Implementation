function HWK5_LicensePlateRecognition()
  clc; clear all;
  close all;
  
  % Load and binarize test image
  imgPlate_RGB = imread('LicensePlate_Custom.png');
  imgPlate_Gray = rgb2gray(imgPlate_RGB);
  
  % Specify ROI in image where you will search for the license plate
  % characters
  % YOU NEED TO COMPLETE THIS !!
  ROI_rows = 90:150; 
  ROI_cols = 20:450;
  imgPlate_ROI = imgPlate_Gray(ROI_rows,ROI_cols);
  % Otsu thresholding
  [~,threshold] = my_GrayThresh(imgPlate_Gray); 
  
  % Convert gray-scale image to binary
  % YOU NEED TO COMPLETE THIS !!
%    imgPlate_Bin = double(imgPlate_Gray < threshold);
  imgPlate_Bin = imbinarize(imgPlate_ROI, threshold);  
  % Display thesrholded image of license plate
  figure(1); 
  imshow(imgPlate_Bin);
  title('binarized license plate');
  
  % Load and binarize character templates
  letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  imLetterTemplates = cell(1, length(letters));
  figure(2); 
  for nLetter = 1:length(letters)
    imgLetter_RGB = imread(sprintf('Character_Templates/%s.png', letters(nLetter)));
    imgLetter_Gray = rgb2gray(imgLetter_RGB);
    
    % Binarise image....YOU NEED TO COMPLETE THIS !!
%     imLetterTemplates{nLetter} = double(imgLetter_Gray < threshold);
    imLetterTemplates{nLetter} = imbinarize(imgLetter_Gray, threshold);
    
    % Display
    subplot(6,6,nLetter);
    imshow( imLetterTemplates{nLetter} );
  end % nLetter 
  title('Character Templates')
  
  % Instructions
  % imLetterTemplates{1} contains 62x62 image of character A
  % imLetterTemplates{2} contains 62x62 image of character B
  % and so forth
  
  % Detect each character by applyign a hit-miss transform
  % YOU NEED TO COMPLETE THIS !!
  for nLetter = 1:length(letters)
    % Structuring element for letter
    B1 = imLetterTemplates{nLetter};
    % Structuring element for boundary of letter
    D1 = [0 0 1 0 0; 0 1 1 1 0; 1 1 1 1 1; 0 1 1 1 0; 0 0 1 0 0];
    D2 = [0 1 0; 1 1 1; 0 1 0];
    B2 = imdilate(B1,D1) - imdilate(B1,D2);
    % Obtained by subtracting dilated version of template from template
    
    % Hit or Miss transform
    C = bwhitmiss(imgPlate_Bin,B1,B2);
    % Compute sum in ROI
    sum_ROI = sum(sum(C));
    % Check if hit
    if sum_ROI > 0
      fprintf('Detected character %s\n', letters(nLetter));
      % Display result of dilating output of hit-miss 
    end
  end % nLetter
  
end