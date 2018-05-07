% Project 4 -- B.2.1 Segmentation of static images
% Apply the assigned three segmentation techniques in matitk to the two
% static images.

%% open two static images and get the demensions.
clear;
filename1 = '60x_02.tif';
filename2 = 'Blue0001.tif';

% To segment each image, comment / uncomment the target image line and 
% choose its relative segmentation section below.

I = double(imread(filename1));
%I = double(imread(filename2));

size1 = size(I);

D = zeros(size1(1),size1(2),2);
D(1:size1(1),1:size1(2),1) = I(1:size1(1),1:size1(2));
D(1:size1(1),1:size1(2),2) = I(1:size1(1),1:size1(2));


%% Image segmentation for file '60x_02.tif'. 
% SNC: neighborhood connected segmentation
SNC_res = matitk('SNC', [2, 2, 2, 800, 1800, 255], double(D), [], [20, 20, 1]);
figure; imagesc(squeeze(SNC_res(:,:,1))); colormap gray; axis off; axis equal; 

snc_res = squeeze(SNC_res(:,:,1));
imwrite(snc_res, '60_SNC.tif');

%% SOT: Otsu threshold segmentation
% implement segmentation using Otsu's method
SOT_res = matitk('SOT',[max(D(:))], double(D));
figure; imagesc(squeeze(SOT_res(:,:,1))); colormap gray; axis off; axis equal; 

sot_res = squeeze(SOT_res(:,:,1));
imwrite(sot_res, '60_SOT.tif');

%% SLLS: Laplacian level set segmentation

% Gauss
gauss_res = matitk('fga', [10, 10], double(D));
figure; imagesc(squeeze(gauss_res(:, :, 1))); colormap gray; axis off; axis equal;

% Gradient
gradient_res = matitk('FGM', [], double(gauss_res));
figure; imagesc(squeeze(gradient_res(:, :, 1))); colormap gray; axis off; axis equal;

% SLLS
SLLS_res = matitk('slls', [30, 1, 1.0, 0.02, 800], double(D), double(gradient_res));
figure; imagesc(squeeze(SLLS_res(:, :, 1))); colormap gray; axis off; axis equal;

slls_res = squeeze(SLLS_res(:, :, 1));
imwrite(slls_res, '60_SLLS.tif');

%% Image segmentation for file 'Blue0001.tif'. 
% SNC: neighborhood connected segmentation
SNC_res = matitk('SNC', [2, 2, 2, 0, 70, 255], double(D),[], [20, 20, 1]);
figure; imagesc(squeeze(1-SNC_res(:,:,1))); colormap gray; axis off; axis equal; 

snc_res = squeeze(1-SNC_res(:,:,1));
imwrite(snc_res, 'Blue_SNC.tif');

%% SOT: Otsu threshold segmentation
% implement segmentation using Otsu's method
SOT_res = matitk('SOT',[max(D(:))], double(D));
figure; imagesc(squeeze(SOT_res(:,:,1))); colormap gray; axis off; axis equal; 

sot_res = squeeze(SOT_res(:,:,1));
imwrite(sot_res, 'Blue_SOT.tif');

%% SLLS: Laplacian level set segmentation

% Gauss
gauss_res = matitk('fga', [0.1, 1], double(D));
figure; imagesc(squeeze(gauss_res(:, :, 1))); colormap gray; axis off; axis equal;

% Gradient
gradient_res = matitk('FGM', [], double(gauss_res));
figure; imagesc(squeeze(gradient_res(:, :, 1))); colormap gray; axis off; axis equal;

% SLLS
SLLS_res = matitk('slls', [4, 1, 1.0, 0.02, 800], double(D), double(gradient_res));
figure; imagesc(squeeze(1-SLLS_res(:, :, 1))); colormap gray; axis off; axis equal;

slls_res = squeeze(1-SLLS_res(:, :, 1));
imwrite(slls_res, 'Blue_SLLS.tif');
