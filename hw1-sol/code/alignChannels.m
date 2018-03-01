function [imShift, predShift] = alignChannels(im, maxShift)
% ALIGNCHANNELS align channels in an image.
%   [IMSHIFT, PREDSHIFT] = ALIGNCHANNELS(IM, MAXSHIFT) aligns the channels in an
%   NxMx3 image IM. The first channel is fixed and the remaining channels
%   are aligned to it within the maximum displacement range of MAXSHIFT (in
%   both directions). The code returns the aligned image IMSHIFT after
%   performing this alignment. The optimal shifts are returned as in
%   PREDSHIFT a 2x2 array. PREDSHIFT(1,:) is the shifts  in I (the first) 
%   and J (the second) dimension of the second channel, and PREDSHIFT(2,:)
%   are the same for the third channel.


% Sanity check
assert(size(im,3) == 3);
assert(all(maxShift > 0));

% Dummy implementation (replace this with your own)
predShift = zeros(2, 2);

imShift = im;

[row, col, ~] = size(im);

row_start = 1;
row_end = row;
col_start = 1;
col_end = col;

rCh = double(im(:,:,1));
gCh = double(im(:,:,2));
bCh = double(im(:,:,3));

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