clc
clear
close all

%% 1. load images and convert them to gray and double

category = 'ledge';
imageName1 = '1.jpg';
imageName2 = '2.jpg';
imageName3 = '3.jpg';
dataDir = fullfile('..','data', category);
outputDir = fullfile('..','output', category);

% imageName1 = 'shanghai-03.png';
% imageName2 = 'shanghai-05.png';
% imageName3 = 'shanghai-07.png';
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
    fprintf('1 and 2 first\n');
    imageName = [category, '_1_2.png']; imwrite(stitched_im_1_2, fullfile(outputDir, imageName));
    [stitched_im, num_match] = stitch_images(stitched_im_1_2, im3_rgb, 'harris', 'sift', 'homography', 1);
elseif (num_match_2_3 >= num_match_1_2) && (num_match_2_3 >= num_match_1_2)    
    fprintf('2 and 3 first\n');
    imageName = [category, '_2_3.png']; imwrite(stitched_im_2_3, fullfile(outputDir, imageName));
    [stitched_im, num_match] = stitch_images(stitched_im_2_3, im1_rgb, 'harris', 'sift', 'homography', 1);
else
    fprintf('1 and 3 first\n');
    imageName = [category, '_1_3.png']; imwrite(stitched_im_1_3, fullfile(outputDir, imageName));
    [stitched_im, num_match] = stitch_images(stitched_im_1_3, im2_rgb, 'harris', 'sift', 'homography', 1);
end

imageName = [category, '_full.png']; imwrite(stitched_im, fullfile(outputDir, imageName));
