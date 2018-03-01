clear 

% Path to your data directory
dataDir = fullfile('..','output','prokudin-gorskii');
outDir = fullfile('..', 'output', 'demosaic-prokudin-gorkii');

% List of images
imageNames = {'00125-aligned.jpg','00149-aligned.jpg',	'00153-aligned.jpg', ... 
              '00351-aligned.jpg','00398-aligned.jpg', '01112-aligned.jpg'};
numImages = length(imageNames);

for i = 1:length(imageNames)
    
    % Read image
    im = imread(fullfile(dataDir, imageNames{i}));
    % Convert to double
    im = im2double(im);
    
    mosim = mosaicImage(im);
    output = demosaicImage(mosim, 'adagrad');
    
    outimageName = sprintf([imageNames{i}(1:end-5) '-demosaic.jpg']);
    outimageName = fullfile(outDir, outimageName);
    imwrite([im output], outimageName, 'jpg');
end