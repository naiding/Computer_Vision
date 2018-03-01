function [imShift, predShift] = alignChannels_extra_credit(im, maxShift)
% ALIGNCHANNELS align channels in an image.
% To use this function, you just need to call it by simply change
%  "output = demosaicImage(input, method);"
%   to 
%  "output = demosaicImage_extra_credit(input, method);"
%  in runDemosaicing.m

assert(size(im,3) == 3);
assert(all(maxShift > 0));

predShift = zeros(2, 2);

imShift = im;

[row, col, ~] = size(im);

row_start = ceil(0.2*row);
row_end = floor(0.8*row);
col_start = ceil(0.2*col);
col_end = floor(0.8*col);

rCh = double(edge(im(:,:,1)));
gCh = double(edge(im(:,:,2)));
bCh = double(edge(im(:,:,3)));

gMaxCorr = 0;
bMaxCorr = 0;

rBox = rCh(row_start:row_end, col_start:col_end);

for i = -maxShift(1):maxShift(1)
    for j = -maxShift(2):maxShift(2)
        
        gChShift = circshift(gCh, [i j]);
        gBox = gChShift(row_start:row_end, col_start:col_end);
        if rBox(:)'*gBox(:) > gMaxCorr
            gMaxCorr = rBox(:)'*gBox(:);
            predShift(1,:) = [i j];
            imShift(:,:,2) = circshift(im(:,:,2), [i j]);
        end
        
        bChShift = circshift(bCh, [i j]);
        bBox = bChShift(row_start:row_end, col_start:col_end);
        if rBox(:)'*bBox(:) > bMaxCorr
            bMaxCorr = rBox(:)'*bBox(:);
            predShift(2,:) = [i j];
            imShift(:,:,3) = circshift(im(:,:,3), [i j]);
        end
        
    end
end