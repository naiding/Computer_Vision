clear

im = imread('../data/demosaic/ip.jpg');
im = im2double(im);

maxShift = [15 15];

% Randomly shift channels
[channels, gtShift]  = randomlyShiftChannels(im, maxShift);

r = channels(:,:,1);
g = channels(:,:,2);
b = channels(:,:,3);

% figure(1); clf;
% subplot(1,2,1); imagesc(channels); axis image off;
% title('Input image');

channels_(:,:,1) = channels(:,:,1);
channels_(:,:,2) = circshift(channels(:,:,2), [-gtShift(1,1) -gtShift(1,2)]);
channels_(:,:,3) = circshift(channels(:,:,3), [-gtShift(2,1) -gtShift(2,2)]);

% subplot(1,2,2); imagesc(channels_); axis image off;
% title('Aligned image');

 

r_ = channels_(:,:,1);
g_ = channels_(:,:,2);
b_ = channels_(:,:,3);

r(:)'*g_(:) - r(:)'*g(:)
r(:)'*b_(:) - r(:)'*b(:)