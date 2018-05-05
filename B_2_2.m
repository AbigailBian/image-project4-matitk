% Project 4 -- B.2.2 Segmentation of image series

% load image sequences
filepath = 'Mito_GFP_a01/';
files = dir(strcat(filepath, '*.tif'));
numfiles = length(files);

%% Apply the assigned segmentation techniques to the time-lapse image
% sequence and generate movies to visualize the segmentation results.

% SOT
% mkdir('SOT_res');
for i = 1 : numfiles
    img = imread(strcat(filepath, files(i).name));
    imgSize = size(img);
    
    D = zeros(imgSize(1),imgSize(2),2);
    D(1:imgSize(1),1:imgSize(2),1) = img(1:imgSize(1),1:imgSize(2));
    D(1:imgSize(1),1:imgSize(2),2) = img(1:imgSize(1),1:imgSize(2));
    
    SOT_res = matitk('SOT', [max(D(:))], double(D));
    imagesc(squeeze(SOT_res(:,:,1))); colormap gray; axis off; axis equal; 

    f = fullfile('SOT_res', strcat('SOT_', num2str(i), '.tif'));
    imwrite(SOT_res(:,:,1), f);
end



%% SLLS
mkdir('SLLS_res');
for i = 1 : numfiles
    img = imread(strcat(filepath, files(i).name));
    imgSize = size(img);
    
    D = zeros(imgSize(1),imgSize(2),2);
    D(1:imgSize(1),1:imgSize(2),1) = img(1:imgSize(1),1:imgSize(2));
    D(1:imgSize(1),1:imgSize(2),2) = img(1:imgSize(1),1:imgSize(2));
    
    % Gauss
    gauss_res = matitk('fga', [0.10, 1], double(D));
    imagesc(squeeze(gauss_res(:, :, 1))); colormap gray; axis off; axis equal;

    % Gradient
    gradient_res = matitk('FGM', [], double(gauss_res));
    imagesc(squeeze(gradient_res(:, :, 1))); colormap gray; axis off; axis equal;

    % SLLS
    SLLS_res = matitk('slls', [30, 1, 1.0, 0.02, 800], double(D), double(gradient_res));
    imagesc(squeeze(1-SLLS_res(:, :, 1))); colormap gray; axis off; axis equal;

    f = fullfile('SLLS_res', strcat('SLLS_', num2str(i), '.tif'));
    imwrite(1-SLLS_res(:,:,1), f);
end

