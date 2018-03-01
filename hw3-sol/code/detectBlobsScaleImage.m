function blobs = detectBlobsScaleImage(im)
% DETECTBLOBS detects blobs in an image
%   BLOBS = DETECTBLOBSCALEIMAGE(IM, PARAM) detects multi-scale blobs in IM.
%   The method uses the Laplacian of Gaussian filter to find blobs across
%   scale space. This version of the code scales the image and keeps the
%   filter same for speed. 
% 
% Input:
%   IM - input image
%
% Ouput:
%   BLOBS - n x 4 array with blob in each row in (x, y, radius, score)
%
% This code is part of:
%
%   CMPSCI 670: Computer Vision, Fall 2014
%   University of Massachusetts, Amherst
%   Instructor: Subhransu Maji
%
%   Homework 3: Blob detector

%% Initialize some parameters
im = im2double(rgb2gray(im));
[im_height, im_width] = size(im);

initial_sigma = 2;
k = 1.2;
levels = 12;
filter_size = 2 * ceil(3 * initial_sigma) - 1;
filter_kernel = fspecial('log', filter_size, initial_sigma);

suppress_size = 3;
threshold = 0.0008;

%% generate scale space
% fprintf('Start generating scale space\n');
scale_space = zeros(im_height, im_width, levels);
for i = 1:levels
    im_ds = imresize(im, 1 / power(k, i-1));
    filter_image = imfilter(im_ds, filter_kernel, 'same', 'replicate');   
    filter_image = filter_image .^ 2;
    scale_space(:,:,i) = imresize(filter_image, size(im), 'bilinear');
end

%% do non-maximum-suppression
% fprintf('Start non-maximum-suppression\n');
maximum_scale_space = scale_space;
for i = 1:levels
    maximum_scale_space(:,:,i) = ordfilt2(maximum_scale_space(:,:,i), suppress_size ^ 2, ones(suppress_size));
end

for i = 1:levels
    maximum_scale_space(:,:,i) = max(maximum_scale_space(:,:,max(1, i-1):min(levels, i+1)), [], 3);
end

maximum_scale_space = (maximum_scale_space == scale_space) .* maximum_scale_space;

%% collect result
% fprintf('Start collecting result\n');
blobs = [];
for i = 1:levels
    [row, col] = find(maximum_scale_space(:,:,i) >= threshold);
    radius = sqrt(2) * initial_sigma * power(k, i-1);
    for j = 1:length(row)
        blobs = [blobs; col(j), row(j), radius, maximum_scale_space(row(j), col(j), i)];
    end
end

fprintf('End. Generated %d blobs\n', size(blobs, 1));

%% Dummy - returns a blob at the center of the image
% blobs = round([size(im,2)*0.5 size(im,1)*0.5 0.25*min(size(im,1), size(im,2)) 1]);