function [] = show_matches(im1, im2, match_group1, match_group2)

num_match = size(match_group1, 2);
fprintf('There are %d matches found.\n', num_match);
% Concatenate images
[h1, w1] = size(im1);
[h2, ~] = size(im2);
if h1 > h2
    im2 = padarray(im2, [h1-h2 0], 'post');
else
    im1 = padarray(im1, [h2-h1 0], 'post');
end

imc = cat(2, im1, im2);

figure, imshow(imc), hold on, axis image off;

match_group2(1, :) = match_group2(1, :) + w1;

for i = 1:num_match
    plot(match_group1(1, i), match_group1(2, i), 'rs');
    plot(match_group2(1, i), match_group2(2, i), 'rs');
    line([match_group1(1, i), match_group2(1, i)], [match_group1(2, i), match_group2(2, i)], 'LineWidth', 1.2);
end
    