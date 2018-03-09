function [inliers_group1, inliers_group2, transf, sample] = ransac(num_iters, thres, method, match_group1, match_group2)

fprintf('Running ransac. ');

inliers = []; transf = []; sample = [];
num_match = size(match_group1, 2);

switch method
    case 'affine'
        for iter = 1:num_iters
            selected_points = randperm(num_match, 3);

            x = match_group1(1, selected_points);
            y = match_group1(2, selected_points);
            xp = match_group2(1, selected_points);
            yp = match_group2(2, selected_points);

            A = [x(1), y(1), 0, 0, 1, 0;
                 0, 0, x(1), y(1), 0, 1;
                 x(2), y(2), 0, 0, 1, 0;
                 0, 0, x(2), y(2), 0, 1;
                 x(3), y(3), 0, 0, 1, 0;
                 0, 0, x(3), y(3), 0, 1];
            b = [xp(1); yp(1); xp(2); yp(2); xp(3); yp(3)];

            transf_initial = A \ b;
            M = [transf_initial(1), transf_initial(2); transf_initial(3), transf_initial(4)];
            T = [transf_initial(5); transf_initial(6)];

            point_true = match_group2(1:2, :);
            point_trans = M * match_group1(1:2, :) + T;
            error = sqrt(sum((point_trans - point_true).^2));
            inliers_new = find(error < thres);

            if length(inliers_new) > length(inliers)
                inliers = inliers_new;
%                 transf = cat(2, inv(M), -inv(M) * T);
                transf = [M T; 0 0 1];
            end
        end

    case 'homography'
        for iter = 1:num_iters
            if num_match < 4
                inliers = [];
                inliers = [];
                transf = [];
                sample = [];
                break;
            end

            selected_points = randsample(num_match, 4);

            x = match_group1(1, selected_points);
            y = match_group1(2, selected_points);
            xp = match_group2(1, selected_points);
            yp = match_group2(2, selected_points);
            
            H = cal_homography(x, y, xp, yp);

            if (rank(H) < 3)
                continue;
            end

            error = cal_error(H, match_group1, match_group2);
            inliers_new = find(error < thres);

            if (length(inliers_new) > length(inliers)) && (length(inliers_new) >= 5)
                inliers = inliers_new;
                transf = cal_homography(match_group1(1, inliers), match_group1(2, inliers), match_group2(1, inliers), match_group2(2, inliers));
%                 sum(error1(inliers_new).^2) / length(inliers_new)
%                 sum(cal_error(transf, match_group1(:, inliers), match_group2(:, inliers))) / length(inliers)
                sample = [match_group1(:, selected_points);match_group2(:, selected_points)];
                
            end
        end
end

inliers_group1 = match_group1(:, inliers);
inliers_group2 = match_group2(:, inliers);

fprintf('Find %d inliers.\n', length(inliers));

end

function H = cal_homography(x, y, xp, yp)
    
    A = [];
    for i = 1:length(x)
        A = [A; 0, 0, 0, x(i), y(i), 1, -yp(i)*x(i), -yp(i)*y(i), -yp(i);
                x(i), y(i), 1, 0, 0, 0, -xp(i)*x(i), -xp(i)*y(i), -xp(i)];
    end

    [~, ~, V] = svd(A, 0); 
    H = reshape(V(:, end), 3, 3)';
    
end

function error = cal_error(H, group1, group2)

    point_true = group2;
    point_trans = H * group1;
    point_trans = point_trans ./ point_trans(3, :);
    error = sqrt(sum((point_trans - point_true).^2 ));
    
end


