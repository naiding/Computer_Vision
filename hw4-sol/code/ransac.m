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
                transf = cat(2, inv(M), -inv(M) * T);
            end
        end

    case 'homography'
        for iter = 1:num_iters
            selected_points = randsample(num_match, 4);

            x = match_group1(1, selected_points);
            y = match_group1(2, selected_points);
            xp = match_group2(1, selected_points);
            yp = match_group2(2, selected_points);

            A = [0, 0, 0, x(1), y(1), 1, -yp(1)*x(1), -yp(1)*y(1), -yp(1);
                 x(1), y(1), 1, 0, 0, 0, -xp(1)*x(1), -xp(1)*y(1), -xp(1);
                 0, 0, 0, x(2), y(2), 1, -yp(2)*x(2), -yp(2)*y(2), -yp(2);
                 x(2), y(2), 1, 0, 0, 0, -xp(2)*x(2), -xp(2)*y(2), -xp(2);
                 0, 0, 0, x(3), y(3), 1, -yp(3)*x(3), -yp(3)*y(3), -yp(3);
                 x(3), y(3), 1, 0, 0, 0, -xp(3)*x(3), -xp(3)*y(3), -xp(3);
                 0, 0, 0, x(4), y(4), 1, -yp(4)*x(4), -yp(4)*y(4), -yp(4);
                 x(4), y(4), 1, 0, 0, 0, -xp(4)*x(4), -xp(4)*y(4), -xp(4)];

            [~, ~, V] = svd(A, 0); H = reshape(V(:, end), 3, 3)';

            if (rank(H) < 3)
                continue;
            end

            point_true = match_group2;
            point_trans = H * match_group1;
            point_trans = point_trans ./ point_trans(3, :);
            error1 = sqrt(sum((point_trans - point_true).^2 ));

            point_true = match_group1;
            point_trans = H \ match_group2;
            point_trans = point_trans ./ point_trans(3, :);
            error2 = sqrt(sum((point_trans - point_true).^2));

            inliers_new = find((error1 + error2) < thres);

            if length(inliers_new) > length(inliers)
                inliers = inliers_new;
                transf = inv(H);
                sample = [match_group1(:, selected_points);match_group2(:, selected_points)];
            end
        end
end

inliers_group1 = match_group1(:, inliers);
inliers_group2 = match_group2(:, inliers);

fprintf('Find %d inliers.\n', length(inliers));
