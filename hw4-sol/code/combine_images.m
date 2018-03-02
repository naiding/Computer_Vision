function im = combine_images(im1_rgb, im2_rgb, H, method)

im1 = im2double(im1_rgb);
im2 = im2double(im2_rgb);

[h2, w2, ~] = size(im2);

switch method
    case 'affine'
        T = maketform('affine', H');
    case 'homography'
        T = maketform('projective', H');
end

[im1t, X, Y] = imtransform(im1, T, 'nearest');
[h1t, w1t, ~] = size(im1t);

% Get bounds for transformed coordinates
txmin = floor(X(1));
txmax = ceil(X(2));
tymin = floor(Y(1));
tymax = ceil(Y(2));

% Get bounds for stitched images
xmin = min(1, txmin);
xmax = max(w2, txmax);
ymin = min(1, tymin);
ymax = max(h2, tymax);

h = ymax-ymin+1;
w = xmax-xmin+1;

im = zeros(h, w, 3);
ox1 = max(0, txmin); oy1 = max(0, tymin);
ox2 = max(0, -xmin+1); oy2 = max(0, -ymin+1);

% Paste the two images
im(oy1+(1:h1t), ox1+(1:w1t), :) = im1t;
im(oy2+(1:h2), ox2+(1:w2), :) = im2;

im_tmp = zeros(size(im));
im_tmp(oy1+(1:h1t), ox1+(1:w1t), :) = im1t;

mask = zeros(size(im, 1), size(im, 2));
mask(oy2+(1:h2), ox2+(1:w2)) = 1;
mask = logical(mask);

im_r = im(:, :, 1);
im_g = im(:, :, 2);
im_b = im(:, :, 3);

im_tmp_r = im_tmp(:, :, 1);
im_tmp_g = im_tmp(:, :, 2);
im_tmp_b = im_tmp(:, :, 3);

mask2 = (im_tmp_r & mask);

im_r(mask2) = (im_r(mask2) + im_tmp_r(mask2)) / 2;
im_g(mask2) = (im_g(mask2) + im_tmp_g(mask2)) / 2;
im_b(mask2) = (im_b(mask2) + im_tmp_b(mask2)) / 2;

im = cat(3, im_r, im_g, im_b);
