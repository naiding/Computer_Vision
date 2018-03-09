clc
clear
close all

load('H.mat');
H = inv(transf);

imageName1 = 'uttower_left.jpg';
imageName2 = 'uttower_right.jpg';
dataDir = fullfile('..','data');

im1_rgb = imread(fullfile(dataDir, imageName1));
im2_rgb = imread(fullfile(dataDir, imageName2));

im1 = im2double(im1_rgb);
im2 = im2double(im2_rgb);

[h1, w1, ~] = size(im1);
[h2, w2, ~] = size(im2);

T = maketform('projective', H');
[im1t, X, Y] = imtransform(im1, T);
[h1t, w1t, ~] = size(im1t);

X(1) = floor(X(1));
X(2) = ceil(X(2));
Y(1) = floor(Y(1));
Y(2) = ceil(Y(2));

im = zeros(-Y(1) + max(Y(2), h2), -X(1) + max(X(2), w2), 3);
im(1:h1t, 1:w1t, :) = im1t;
im(-Y(1) + (1:h2), -X(1) + (1:w2), :) = im2;

im_tmp = zeros(size(im));
im_tmp(1:h1t, 1:w1t, :) = im1t;

mask = zeros(size(im, 1), size(im, 2));
mask(-Y(1) + (1:h2), -X(1) + (1:w2)) = 1;
mask = logical(mask);

im_r = im(:, :, 1);
im_g = im(:, :, 2);
im_b = im(:, :, 3);

im_tmp_r = im_tmp(:, :, 1);
im_tmp_g = im_tmp(:, :, 2);
im_tmp_b = im_tmp(:, :, 3);


mask2 = im_tmp_r & mask;

im_r(mask2) = (im_r(mask2) + im_tmp_r(mask2)) / 2;
im_g(mask2) = (im_g(mask2) + im_tmp_g(mask2)) / 2;
im_b(mask2) = (im_b(mask2) + im_tmp_b(mask2)) / 2;

im = cat(3, im_r, im_g, im_b);

% tic;
% for i = -Y(1) + (1:h2)
%     for j = -X(1) + (1:w2)
%         if sum(im_tmp(i, j, :)) ~= 0
%             im(i, j, :) = (im(i, j, :) + im_tmp(i, j, :)) / 2;
%         end
%     end
% end
% toc;

figure;imshow(im)