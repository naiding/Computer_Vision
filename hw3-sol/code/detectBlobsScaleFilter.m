function blobs = detectBlobsScaleFilter(im)
% DETECTBLOBS detects blobs in an image
%   BLOBS = DETECTBLOBSSCALEFILTER(IM, PARAM) detects multi-scale blobs in IM.
%   The method uses the Laplacian of Gaussian filter to find blobs across
%   scale space. This version of the code scales the filter and keeps the
%   image same which is slow for big filters.
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
suppress_size = 3;
threshold = 0.01;

%% generate scale space
% fprintf('Start generating scale space\n');
scale_space = zeros(im_height, im_width, levels);
for i = 1:levels
    sigma = initial_sigma * power(k, i-1);
    filter_size = 2 * ceil(3 * sigma) - 1;
    filter_kernel = power(sigma, 2) * fspecial('log', filter_size, sigma);
    filter_image = imfilter(im, filter_kernel, 'same', 'replicate');
    scale_space(:,:,i) = filter_image .^ 2;
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

%% filter edges and corners
% fprintf('Start filtering edges and corners\n');
% new_blobs = [];
% for i = 1:size(blobs, 1)
%     row = blobs(i, 1);  col = blobs(i, 2); radius = blobs(i, 3);
%     if (row - radius >= 1) && (row + radius <= im_height) && (col - radius >= 1) && (col + radius <= im_width)
%         im_patch = im(ceil(row-radius):floor(row+radius), ceil(col-radius):floor(col+radius));
%         im_patch_dx = imfilter(im_patch, [1, -1], 'same', 'replicate');
%         im_patch_dy = imfilter(im_patch, [1; -1], 'same', 'replicate');
%         M = [sum(sum(im_patch_dx.^2)), sum(sum(im_patch_dx.*im_patch_dy)); sum(sum(im_patch_dx.*im_patch_dy)), sum(sum(im_patch_dy.^2))];
%         R = det(M) - 0.05 * trace(M);
%         if R >= 0
%             new_blobs = [new_blobs; blobs(i, :)];
%         end
%     end
% end
% 
% blobs = new_blobs;

%% Dummy - returns a blob at the center of the image
% blobs = round([size(im,2)*0.5 size(im,1)*0.5 0.25*min(size(im,1), size(im,2)) 1]);