
clear
close all

image_path = '../data/office/';
image_dir = dir([image_path '*.png']);
num_image = length(image_dir);
% image_dir = image_dir(randperm(num_image));

sigma = 5; thresh = 0.0001; r = 5;
feats = [];
feats_id = [];
for i = 1:num_image
    im = imread([image_path image_dir(i).name]);
    
    if size(im, 3) == 1
        im = repmat(im, 1, 1, 3);
    end
    
    images(i).rgb = im;
    images(i).gray = im2double(rgb2gray(im));
    
    [~, row, col] = harris(images(i).gray, sigma, thresh, r, 0);
    radius = r * ones(length(row), 1);
    
    images(i).row = row;
    images(i).col = col;
    images(i).radius = radius;
    images(i).feat = find_sift(images(i).gray, [col, row, radius], 2);
    images(i).feat_start_idx = size(feats, 1) + 1;
    images(i).num_feat = size(images(i).feat, 1);
    
    feats = [feats; images(i).feat];
    feats_id = [feats_id; i*ones(images(i).num_feat, 1)];
end

kdt = KDTreeSearcher(feats);
k = num_image;
for i = 1:num_image
    poll = zeros(num_image, 1);
    for j = images(i).feat_start_idx : images(i).feat_start_idx + images(i).num_feat - 1
        idx = knnsearch(kdt, feats(j, :), 'K', k);
        for k = 1:length(idx)
            poll(feats_id(idx(k))) = poll(feats_id(idx(k))) + 1;
        end
    end
    images(i).poll = poll;
end

m = 2;
transf_method = 'homography';
for i = 1:num_image
    poll = images(i).poll;
    poll(i) = 0;
    neighbors = [];
    for j = 1:m
        [~, idx] = max(poll);
        
        % calculate distance
        feat_dist = dist2(images(i).feat, images(idx).feat);
        
        % find putative matches
        match_idx = find_matches(feat_dist);
        match_group1 = [images(i).col(match_idx(:, 1)), images(i).row(match_idx(:, 1)), ones(size(match_idx, 1), 1)]';
        match_group2 = [images(idx).col(match_idx(:, 2)), images(idx).row(match_idx(:, 2)), ones(size(match_idx, 1), 1)]';
        num_iters = 1000; thres = 10;
        [inliers_group1, inliers_group2, transf, sample] = ransac(num_iters, thres, transf_method, match_group1, match_group2);
        
        % exclude outlier image
        nf = size(match_group1, 2);
        ni = size(inliers_group1, 2);
        
        if ni > 5.9 + 0.22*nf
            neighbors = [neighbors; idx];
        end
        poll(idx) = 0;
    end
    images(i).neighbors = neighbors;
end

% assume the first one is valid
valid_nodes = [1];
for i = 1:num_image
    valid_nodes = [valid_nodes; images(i).neighbors];
end
valid_nodes = unique(valid_nodes);


stitched_nodes = [1];
stitch_im = images(1).rgb;
neighbors = [];
while length(stitched_nodes) < length(valid_nodes)
    for i = 1:length(stitched_nodes)
        neighbors = [neighbors; images(stitched_nodes(i)).neighbors];
    end
    neighbors = unique(neighbors);
    neighbors = setdiff(neighbors, stitched_nodes);
    
    for j = 1:length(neighbors)
        [stitch_im, ~] = stitch_images(stitch_im, images(neighbors(j)).rgb, 'harris', 'sift', 'homography', 0);
%         [stitch_im, ~] = stitch_images_with_feats(stitch_im, images(neighbors(j)).rgb, 'harris', 'sift', 'homography', 0);
    end
    stitched_nodes = [stitched_nodes; neighbors];
end
