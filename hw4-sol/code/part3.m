
clear
close all

image_path = '../data/shanghai_test/';
image_dir = dir([image_path '*.png']);
num_image = length(image_dir);
images = cell(length(num_image), 1);
for i = 1:num_image
%     images{i} = imread([image_path image_dir(i).name]);
    images{i} = repmat(imread([image_path image_dir(i).name]), 1, 1, 3);
end

num_match = zeros(num_image, num_image);

for i = 1:num_image
    for j = 1:num_image
        [~, num_match_tmp] = stitch_images(images{i}, images{j}, 'homography', 0);
        num_match(i, j) = num_match_tmp;
    end
end

% [stitched_im_1_2, num_match_1_2] = stitch_images(im1_rgb, im2_rgb, 'homography', 0);
% [stitched_im_1_3, num_match_1_3] = stitch_images(im1_rgb, im3_rgb, 'homography', 0);
% [stitched_im_2_3, num_match_2_3] = stitch_images(im2_rgb, im3_rgb, 'homography', 0);
% 
% if (num_match_1_2 >= num_match_1_3) && (num_match_1_2 >= num_match_2_3)
%     [stitched_im, num_match] = stitch_images(stitched_im_1_2, im3_rgb, 'homography', 1);
% elseif (num_match_2_3 >= num_match_1_2) && (num_match_2_3 >= num_match_1_2)    
%     [stitched_im, num_match] = stitch_images(stitched_im_2_3, im1_rgb, 'homography', 1);
% else
%     [stitched_im, num_match] = stitch_images(stitched_im_1_3, im2_rgb, 'homography', 1);
% end