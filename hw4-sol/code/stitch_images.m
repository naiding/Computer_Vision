function [stitchIm, num_match] = stitch_images(im1_rgb, im2_rgb, feat_method, descri_method, transf_method, disp)


if size(im1_rgb, 3) == 1
    im1_rgb = repmat(im1_rgb, 1, 1, 3); 
end

if size(im2_rgb, 3) == 1
    im2_rgb = repmat(im2_rgb, 1, 1, 3); 
end

im1 = im2double(rgb2gray(im1_rgb));
im2 = im2double(rgb2gray(im2_rgb));

switch feat_method
    case 'harris'
        fprintf('Running harris feature points.\n');
        sigma = 3; thresh = 0.001; radius = 3;
        [cim1, row1, col1] = harris(im1, sigma, thresh, radius, 0);
        [cim2, row2, col2] = harris(im2, sigma, thresh, radius, 0);
        radius1 = radius * ones(length(row1), 1);
        radius2 = radius * ones(length(row2), 1);
    case 'blob'
        fprintf('Running blob feature points.\n');
        blobs1 = detectBlobsScaleImage(im1);
        blobs2 = detectBlobsScaleImage(im2);
        col1 = blobs1(:, 1); row1 = blobs1(:, 2); radius1 = blobs1(:, 3);
        col2 = blobs2(:, 1); row2 = blobs2(:, 2); radius2 = blobs2(:, 3);
end

switch descri_method
    case 'intensity'
        [match_group1, match_group2] = find_intensity_matches(im1, im2, row1, col1, row2, col2, radius, 0.9);
    case 'sift'    
        % compute sift descriptor
        feat1 = find_sift(im1, [col1, row1, radius1], 2);
        feat2 = find_sift(im2, [col2, row2, radius2], 2);
        
        % calculate distance
        feat_dist = dist2(feat1, feat2);
        
        % find putative matches
        match_idx = find_matches(feat_dist);
        match_group1 = [col1(match_idx(:, 1)), row1(match_idx(:, 1)), ones(size(match_idx, 1), 1)]';
        match_group2 = [col2(match_idx(:, 2)), row2(match_idx(:, 2)), ones(size(match_idx, 1), 1)]';
end

num_iters = 1000; thres = 5;
[inliers_group1, inliers_group2, transf, sample] = ransac(num_iters, thres, transf_method, match_group1, match_group2);

num_match = size(inliers_group1, 2);

if num_match ~= 0
    % stitchIm = merge_images(im1_rgb, im2_rgb, transf, transf_method);
    stitchIm = combine_images(im1_rgb, im2_rgb, transf, transf_method);

    if disp
    %     show_matches(im1, im2, sample(1:2,:), sample(4:5,:));
    %     show_matches(im1, im2, inliers_group1, inliers_group2);
        figure; showMatchedFeatures(im1, im2, inliers_group1(1:2, :)', inliers_group2(1:2, :)' ,'montage');
        figure; imshow(stitchIm);
    end
else
    stitchIm = [];
    num_match = 0;
end


