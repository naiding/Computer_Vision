function [stitchIm, num_match] = stitch_images_with_feats(im1_struct, im2_struct, transf_method, disp)

im1_rgb = im1_struct.rgb;
im2_rgb = im2_struct.rgb;

im1 = im1_struct.gray;
im2 = im2_struct.gray;

row1 = im1_struct.row;
col1 = im1_struct.col;
row2 = im2_struct.row;
col2 = im2_struct.col;
  
% compute sift descriptor
feat1 = im1_struct.feat;
feat2 = im2_struct.feat;

% calculate distance
feat_dist = dist2(feat1, feat2);

% find putative matches
match_idx = find_matches(feat_dist);
match_group1 = [col1(match_idx(:, 1)), row1(match_idx(:, 1)), ones(size(match_idx, 1), 1)]';
match_group2 = [col2(match_idx(:, 2)), row2(match_idx(:, 2)), ones(size(match_idx, 1), 1)]';

num_iters = 1000; thres = 15;
[inliers_group1, inliers_group2, transf, sample] = ransac(num_iters, thres, transf_method, match_group1, match_group2);

num_match = size(inliers_group1, 2);

if num_match ~= 0
    % stitchIm = merge_images(im1_rgb, im2_rgb, transf, transf_method);
    stitchIm = combine_images(im1_rgb, im2_rgb, transf, transf_method);

    if disp
    %     show_matches(im1, im2, sample(1:2,:), sample(4:5,:));
    %     show_matches(im1, im2, inliers_group1, inliers_group2);
        showMatchedFeatures(im1, im2, inliers_group1(1:2, :)', inliers_group2(1:2, :)' ,'montage');
        figure; imshow(stitchIm);
    end
else
    stitchIm = [];
    num_match = 0;
end