clc
clear
close all

%% 1. load images and convert them to gray and double

imageName1 = '1.jpg';
imageName2 = '2.jpg';
imageName3 = '3.jpg';
dataDir = fullfile('..','data', 'pier');
% 
% imageName1 = 'shanghai-01.png';
% imageName2 = 'shanghai-02.png';
% imageName3 = 'shanghai-03.png';
% dataDir = fullfile('..','data', 'shanghai');

im1_rgb = imread(fullfile(dataDir, imageName1));
im2_rgb = imread(fullfile(dataDir, imageName2));
im3_rgb = imread(fullfile(dataDir, imageName3));

% im1_rgb = repmat(im1_rgb, 1, 1, 3);
% im2_rgb = repmat(im2_rgb, 1, 1, 3);
% im3_rgb = repmat(im3_rgb, 1, 1, 3);

[stitched_im_1_2, num_match_1_2] = stitch_images(im1_rgb, im2_rgb, 'harris', 'sift', 'homography', 0);
[stitched_im_1_3, num_match_1_3] = stitch_images(im1_rgb, im3_rgb, 'harris', 'sift', 'homography', 0);
[stitched_im_2_3, num_match_2_3] = stitch_images(im2_rgb, im3_rgb, 'harris', 'sift', 'homography', 0);

if (num_match_1_2 >= num_match_1_3) && (num_match_1_2 >= num_match_2_3)
    [stitched_im, num_match] = stitch_images(stitched_im_1_2, im3_rgb, 'harris', 'sift', 'homography', 1);
elseif (num_match_2_3 >= num_match_1_2) && (num_match_2_3 >= num_match_1_2)    
    [stitched_im, num_match] = stitch_images(stitched_im_2_3, im1_rgb, 'harris', 'sift', 'homography', 1);
else
    [stitched_im, num_match] = stitch_images(stitched_im_1_3, im2_rgb, 'harris', 'sift', 'homography', 1);
end
