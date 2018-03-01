function output = demosaicImage(im, method)
% DEMOSAICIMAGE computes the color image from mosaiced input
%   OUTPUT = DEMOSAICIMAGE(IM, METHOD) computes a demosaiced OUTPUT from
%   the input IM. The choice of the interpolation METHOD can be 
%   'baseline', 'nn', 'linear', 'adagrad'. 

switch lower(method)
    case 'baseline'
        output = demosaicBaseline(im);
    case 'nn'
        output = demosaicNN(im);         % Implement this
    case 'linear'
        output = demosaicLinear(im);     % Implement this
    case 'adagrad'
        output = demosaicAdagrad(im);    % Implement this
end

%--------------------------------------------------------------------------
%                          Baseline demosaicing algorithm. 
%                          The algorithm replaces missing values with the
%                          mean of each color channel.
%--------------------------------------------------------------------------
function mosim = demosaicBaseline(im)
mosim = repmat(im, [1 1 3]); % Create an image by stacking the input
[imageHeight, imageWidth] = size(im);

% Red channel (odd rows and columns);
redValues = im(1:2:imageHeight, 1:2:imageWidth);
meanValue = mean(mean(redValues));
mosim(:,:,1) = meanValue;
mosim(1:2:imageHeight, 1:2:imageWidth, 1) = im(1:2:imageHeight, 1:2:imageWidth);

% Blue channel (even rows and colums);
blueValues = im(2:2:imageHeight, 2:2:imageWidth);
meanValue = mean(mean(blueValues));
mosim(:,:,3) = meanValue;
mosim(2:2:imageHeight, 2:2:imageWidth,3) = im(2:2:imageHeight, 2:2:imageWidth);

% Green channel (remaining places)
% We will first create a mask for the green pixels (+1 green, -1 not green)
mask = ones(imageHeight, imageWidth);
mask(1:2:imageHeight, 1:2:imageWidth) = -1;
mask(2:2:imageHeight, 2:2:imageWidth) = -1;
greenValues = mosim(mask > 0);
meanValue = mean(greenValues);
% For the green pixels we copy the value
greenChannel = im;
greenChannel(mask < 0) = meanValue;
mosim(:,:,2) = greenChannel;

%--------------------------------------------------------------------------
%                           Nearest neighbour algorithm
%--------------------------------------------------------------------------
function mosim = demosaicNN(im)
[imageHeight, imageWidth] = size(im);
mosim = zeros(imageHeight, imageWidth, 3);
mosim(1:2:imageHeight, 1:2:imageWidth, 1) = im(1:2:imageHeight, 1:2:imageWidth);
mosim(2:2:imageHeight, 2:2:imageWidth, 3) = im(2:2:imageHeight, 2:2:imageWidth);

mask = zeros(imageHeight, imageWidth);
mask(1:2:imageHeight, 1:2:imageWidth) = 1;
mask(2:2:imageHeight, 2:2:imageWidth) = 1;
greenValues = im; greenValues(mask>0) = 0;
mosim(:,:, 2) = greenValues;

% fill red value
mosim(1:2:imageHeight, 2:2:imageWidth, 1) = mosim(1:2:imageHeight, (2:2:imageWidth)-1, 1);
mosim(2:2:imageHeight, 1:2:imageWidth, 1) = mosim((2:2:imageHeight)-1, 1:2:imageWidth, 1);
mosim(2:2:imageHeight, 2:2:imageWidth, 1) = mosim((2:2:imageHeight)-1, (2:2:imageWidth)-1, 1);

% fill green value
if mod(imageWidth, 2) == 0
    mosim(1:2:imageHeight, 1:2:imageWidth, 2) = mosim(1:2:imageHeight, (1:2:imageWidth)+1, 2);
else
    mosim(1:2:imageHeight, 1:2:imageWidth-1, 2) = mosim(1:2:imageHeight, (1:2:imageWidth-1)+1, 2);
    mosim(1:2:imageHeight, imageWidth, 2) = mosim(1:2:imageHeight, imageWidth-1, 2);
end
mosim(2:2:imageHeight, 2:2:imageWidth, 2) = mosim(2:2:imageHeight, (2:2:imageWidth)-1, 2);

% fill blue value
mosim(1:2:imageHeight-mod(imageHeight, 2), 1:2:imageWidth-mod(imageWidth, 2), 3) ...
    = mosim((1:2:imageHeight-mod(imageHeight, 2))+1, (1:2:imageWidth-mod(imageWidth, 2))+1, 3);
mosim(2:2:imageHeight, 1:2:imageWidth-mod(imageWidth, 2), 3) ... 
    = mosim(2:2:imageHeight, (1:2:imageWidth-mod(imageWidth, 2))+1, 3);
mosim(1:2:imageHeight-mod(imageHeight, 2), 2:2:imageWidth, 3) ... 
    = mosim((1:2:imageHeight-mod(imageHeight, 2))+1, 2:2:imageWidth, 3);

if mod(imageWidth, 2) == 1
    mosim(1:2:imageHeight-mod(imageHeight, 2), imageWidth, 3) ... 
        = mosim((1:2:imageHeight-mod(imageHeight, 2))+1, imageWidth-1, 3);
    mosim(2:2:imageHeight, imageWidth, 3) = mosim(2:2:imageHeight, imageWidth-1, 3);
end

if mod(imageHeight, 2) == 1
    mosim(imageHeight, 1:2:imageWidth-mod(imageWidth, 2), 3) ... 
        = mosim(imageHeight-1, (1:2:imageWidth-mod(imageWidth, 2))+1, 3);
    mosim(imageHeight, 2:2:imageWidth, 3) = mosim(imageHeight-1, 2:2:imageWidth, 3);
end

% T1 = [0 0 0 ; 0 1 1; 0 1 1];
% mosim(:,:,1) = conv2(mosim(:,:,1), T1, 'same');
% 
% T2 = [0 1 0; 0 1 0; 0 0 0];
% T3 = [0 0 0; 0 1 0; 0 1 0];
% mosim(:,:,2) = conv2(mosim(:,:,2), T2, 'same');
% temp = conv2(mosim(:,:,2), T3, 'same');
% mosim(imageHeight,:,2) = temp(imageHeight, :);
% 
% % fill blue value
% T4 = [1 1 0; 1 1 0; 0 0 0];
% mosim(:,:,3) = conv2(mosim(:,:,3), T1, 'same');
% temp = conv2(mosim(:,:,3), T4, 'same');
% mosim(:,1,3) = temp(:, 1);
% mosim(1,:,3) = temp(1, :);


%--------------------------------------------------------------------------
%                           Linear interpolation
%--------------------------------------------------------------------------
function mosim = demosaicLinear(im)

[imageHeight, imageWidth] = size(im);
mosim = zeros(imageHeight, imageWidth, 3);
mosim(1:2:imageHeight, 1:2:imageWidth, 1) = im(1:2:imageHeight, 1:2:imageWidth);
mosim(2:2:imageHeight, 2:2:imageWidth, 3) = im(2:2:imageHeight, 2:2:imageWidth);

mask = zeros(imageHeight, imageWidth);
mask(1:2:imageHeight, 1:2:imageWidth) = 1;
mask(2:2:imageHeight, 2:2:imageWidth) = 1;
greenValues = im; greenValues(mask>0) = 0;
mosim(:,:, 2) = greenValues;


%%%%%%%%%%%%%%%%%%%%%%%%% normal method
% fill red channel 
T1 = [1/4 1/2 1/4; 1/2 1 1/2; 1/4 1/2 1/4];
mosim(:,:,1) = conv2(mosim(:,:,1), T1, 'same');

% fill green channel
T2 = [0 1/4 0; 1/4 1 1/4; 0 1/4 0];
T3 = [0 1/3 0; 1/3 1 1/3; 0 1/3 0];
temp2 = mosim(:,:,2);
mosim(:,:,2) = conv2(temp2, T2, 'same');
temp2_ = conv2(temp2, T3, 'same');

mosim(1:imageHeight,1,2) = temp2_(1:imageHeight, 1);
mosim(1:imageHeight,imageWidth,2) = temp2_(1:imageHeight, imageWidth);
mosim(1,1:imageWidth,2) = temp2_(1, 1:imageWidth);
mosim(imageHeight,1:imageWidth,2) = temp2_(imageHeight, 1:imageWidth);
mosim(1,1,2) = 0.5 * (temp2(1,2) + temp2(2,1));
% mosim(imageHeight,imageWidth,2) = 0.5 * (temp2(imageHeight-1,imageWidth) + temp2(imageHeight,imageWidth-1));

% fill blue channel
T4 = [1/2 1 1/2; 1 0 1; 1/2 1 1/2];
temp3 = mosim(:,:,3);
mosim(:,:,3) = conv2(temp3, T1, 'same');
temp3_ = conv2(temp3, T4, 'same');

mosim(1:imageHeight,1,3) = temp3_(1:imageHeight, 1);
mosim(1:imageHeight,imageWidth,3) = temp3_(1:imageHeight, imageWidth);
mosim(1,1:imageWidth,3) = temp3_(1, 1:imageWidth);
mosim(imageHeight,1:imageWidth,3) = temp3_(imageHeight, 1:imageWidth);
mosim(1,1,3) = temp3(2,2);


%--------------------------------------------------------------------------
%                           Adaptive gradient
%--------------------------------------------------------------------------
function mosim = demosaicAdagrad(im)
[imageHeight, imageWidth] = size(im);
mosim = zeros(imageHeight, imageWidth, 3);
mosim(1:2:imageHeight, 1:2:imageWidth, 1) = im(1:2:imageHeight, 1:2:imageWidth);
mosim(2:2:imageHeight, 2:2:imageWidth, 3) = im(2:2:imageHeight, 2:2:imageWidth);

mask = zeros(imageHeight, imageWidth);
mask(1:2:imageHeight, 1:2:imageWidth) = 1;
mask(2:2:imageHeight, 2:2:imageWidth) = 1;
greenValues = im; greenValues(mask>0) = 0;
mosim(:,:, 2) = greenValues;

temp1 = mosim(:,:,1);
temp2 = mosim(:,:,2);
temp3 = mosim(:,:,3);

mosim = demosaicLinear(im);

for i = 2:2:(imageHeight-1)
    for j = 2:2:(imageWidth-1)
        
        if abs(temp1(i+1, j+1) - temp1(i-1, j-1)) > abs(temp1(i+1, j-1) - temp1(i-1, j+1))
            mosim(i,j,1) = (temp1(i+1, j-1) + temp1(i-1, j+1)) / 2;
        else
            mosim(i,j,1) = (temp1(i+1, j+1) + temp1(i-1, j-1)) / 2;
        end

        if abs(temp2(i, j+1) - temp2(i, j-1)) > abs(temp2(i+1, j) - temp2(i-1, j))
            mosim(i,j,2) = (temp2(i+1, j) + temp2(i-1, j)) / 2;
        else
            mosim(i,j,2) = (temp2(i, j+1) + temp2(i, j-1)) / 2;
        end
        
        m = i+1; n = j+1;
        if m+1 <= imageHeight && n+1 <= imageWidth    
            if abs(temp3(m+1, n+1) - temp3(m-1, n-1)) > abs(temp3(m+1, n-1) - temp3(m-1, n+1))
                mosim(m,n,3) = (temp3(m+1, n-1) + temp3(m-1, n+1)) / 2;
            else
                mosim(m,n,3) = (temp3(m+1, n+1) + temp3(m-1, n-1)) / 2;
            end
        end
    end
end