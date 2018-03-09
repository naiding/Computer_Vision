
clear
close all

%% load images and convert them to gray and double
% imageName1 = 'uttower_left.jpg';
% imageName2 = 'uttower_right.jpg';
% dataDir = fullfile('..','data');
% 
% imageName2 = 'hill_1.jpg';
% imageName1 = 'hill_2_3.png';
% dataDir = fullfile('..','data');

imageName1 = '1.jpg';
imageName2 = '2.jpg';
dataDir = fullfile('..','data', 'test');

im1_rgb = imread(fullfile(dataDir, imageName1));
im2_rgb = imread(fullfile(dataDir, imageName2));

[stitched_im, num_match] = stitch_images(im1_rgb, im2_rgb, 'harris', 'sift', 'homography', 1);

