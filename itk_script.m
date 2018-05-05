clearvars;
% load image and get the size of this image
filename = 'Blue0001.tif';
Img = double(imread(filename));
imgSz = size(Img);
% show original image
figure; imagesc(Img); colormap gray; axis off; axis equal; 

% in order to use matitk, we have to use 3D data
% so we first build a 3D volume of two layers, and each layer
% contains the original image
D = zeros(imgSz(1),imgSz(2),2);
D(1:imgSz(1),1:imgSz(2),1) = Img(1:imgSz(1),1:imgSz(2));
D(1:imgSz(1),1:imgSz(2),2) = Img(1:imgSz(1),1:imgSz(2));
% implement segmentation using Otsu's method
b = matitk('SOT',[max(D(:))], double(D));
figure; imagesc(squeeze(b(:,:,1))); colormap gray; axis off; axis equal; 
% implement segmentation using Otsu's method
c = matitk('SNC',2, 2, 2, 0, 255, 255, double(D));
figure; imagesc(squeeze(c(:,:,1))); colormap gray; axis off; axis equal; 