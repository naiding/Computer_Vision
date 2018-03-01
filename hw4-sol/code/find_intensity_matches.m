function [match_group1, match_group2] = find_intensity_matches(im1, im2, row1, col1, row2, col2, radius, thres)
    

    fprintf('Running find_intensity_matches.\n');

    num_feat1 = size(row1, 1);
    num_feat2 = size(row2, 1);
    
    feat1 = [];
    for i = 1:num_feat1
        if row1(i)-radius >= 1 && row1(i)+radius <= size(im1, 1)  ...
            && col1(i)-radius >= 1 && col1(i)+radius <= size(im1, 2)
            patch = im1(row1(i)-radius:row1(i)+radius, col1(i)-radius:col1(i)+radius);
            feat1 = [feat1; patch(:)'];
        end
    end
    
    feat2 = [];
    for i = 1:num_feat2
        if row2(i)-radius >= 1 && row2(i)+radius <= size(im2, 1)  ...
            && col2(i)-radius >= 1 && col2(i)+radius <= size(im2, 2)
            patch = im2(row2(i)-radius:row2(i)+radius, col2(i)-radius:col2(i)+radius);
            feat2 = [feat2; patch(:)'];
        end
    end
    
    corr = zeros(size(feat1, 1), size(feat2, 1));
    for i = 1:size(corr, 1)
        for j = 1:size(corr, 2)
            u = feat1(i, :)';
            v = feat2(j, :)';
            ubar = mean(u) * ones(length(u), 1);
            vbar = mean(v) * ones(length(v), 1);
            corr(i,j) = sum((u-ubar).*(v-vbar)) / ( sqrt(sum((u-ubar).^2)) * sqrt(sum((v-vbar).^2)) );
        end
    end
    
    [d1, d2] = find(corr > thres);

    %-----Generate coordinates of matched pixels
    for i=1:size(d1,1)
        D1(:,i) = [col1(d1(i)); row1(d1(i));1];
        D2(:,i) = [col2(d2(i)); row2(d2(i));1];
    end
    
    match_group1 = D1;
    match_group2 = D2;

end

