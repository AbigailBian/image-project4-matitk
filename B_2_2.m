% Project 4 -- B.2.2 Segmentation of image series

%% load image sequences
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

%% Manually tracing -- SOT

% choose frame1, frame10 and frame20
% load images
load('BW1.mat');
load('BW10.mat');
load('BW20.mat');

% SOT
sot_filepath = 'SOT_res/';
f1 = imread(strcat(sot_filepath, 'SOT_1.tif'));
f10 = imread(strcat(sot_filepath, 'SOT_10.tif'));
f20 = imread(strcat(sot_filepath, 'SOT_20.tif'));


[m,n] = size(f1);
total_size = m * n;
logi_f1 = logical(mod(f1, 2));

% Metric I:
% Volumetric Overlap Error: The volumetric overlap error between two sets 
% of voxels and is given in percent and defined as 100(1-(|A n B|/|A u B|)). 
num1 = 0;
num10 = 0;
num20 = 0;
for i=1:m
    for j=1:n
        % !BW && f == 255
        if BW1(i,j) && f1(i,j)==255
            num1 = num1 + 1;
        end
        
        if BW10(i,j) && f10(i,j)==255
            num10 = num10 + 1;
        end

        if BW20(i,j) && f20(i,j)==255
            num20 = num20 + 1;
        end
    end
end

m1_1 = num1/total_size;
m1_10 = num10/total_size;
m1_20 = num20/total_size;

% Metric II: False positive rate
num_pos1 = 0;
num_pos10 = 0;
num_pos20 = 0;
for i=1:m
    for j=1:n
        % !BW && f == 255
        if (~BW1(i,j)) && f1(i,j)==255
            num_pos1 = num_pos1 + 1;
        end
        
        if (~BW10(i,j)) && f10(i,j)==255
            num_pos10 = num_pos10 + 1;
        end

        if (~BW20(i,j)) && f20(i,j)==255
            num_pos20 = num_pos20 + 1;
        end
    end
end

m2_1 = num_pos1/total_size;
m2_10 = num_pos10/total_size;
m2_20 = num_pos20/total_size;


% Metric III: False negative rate
num_neg1 = 0;
num_neg10 = 0;
num_neg20 = 0;
for i=1:m
    for j=1:n
        % BW && f == 0
        if BW1(i,j) && f1(i,j)==0
            num_neg1 = num_neg1 + 1;
        end
        
        if BW10(i,j) && f10(i,j)==0
            num_neg10 = num_neg10 + 1;
        end

        if BW20(i,j) && f20(i,j)==0
            num_neg20 = num_neg20 + 1;
        end
    end
end

m3_1 = num_neg1/total_size;
m3_10 = num_neg10/total_size;
m3_20 = num_neg20/total_size;

%% Manually tracing -- SLLS

% choose frame1, frame10 and frame20
% load images
load('BW1.mat');
load('BW10.mat');
load('BW20.mat');

% SLLS
slls_filepath = 'SLLS_res/';
ff1 = imread(strcat(slls_filepath, 'SLLS_1.tif'));
ff10 = imread(strcat(slls_filepath, 'SLLS_10.tif'));
ff20 = imread(strcat(slls_filepath, 'SLLS_20.tif'));

[m,n] = size(ff1);

% Metric I:
% Volumetric Overlap Error: The volumetric overlap error between two sets 
% of voxels and is given in percent and defined as 100(1-(|A n B|/|A u B|)). 


% Metric II: False positive rate
num_pos1 = 0;
num_pos10 = 0;
num_pos20 = 0;
for i=1:m
    for j=1:n
        % !BW && f == 255
        if (~BW1(i,j)) && ff1(i,j)==255
            num_pos1 = num_pos1 + 1;
        end
        
        if (~BW10(i,j)) && ff10(i,j)==255
            num_pos10 = num_pos10 + 1;
        end

        if (~BW20(i,j)) && ff20(i,j)==255
            num_pos20 = num_pos20 + 1;
        end
    end
end


% Metric III: False negative rate

num_neg1 = 0;
num_neg10 = 0;
num_neg20 = 0;
for i=1:m
    for j=1:n
        % BW && f == 0
        if BW1(i,j) && ff1(i,j)==0
            num_neg1 = num_neg1 + 1;
        end
        
        if BW10(i,j) && ff10(i,j)==0
            num_neg10 = num_neg10 + 1;
        end

        if BW20(i,j) && ff20(i,j)==0
            num_neg20 = num_neg20 + 1;
        end
    end
end