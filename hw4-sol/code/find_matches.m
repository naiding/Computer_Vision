function idx_match = find_matches(feat_dist)

fprintf('Running find_matches. ');

[val, idx2] = min(feat_dist, [], 2);
idx1 = (1:length(idx2))';

% delete repeatable matches
idx1_trim = [];
idx2_trim = [];

for i = 1:length(idx1)
    [r, c] = find(idx2==idx2(i));
    if length(r) == 1
        idx1_trim = [idx1_trim; idx1(i)];
        idx2_trim = [idx2_trim; idx2(i)];
    end
end

% delete unreliable matches
idx1_trim_2 = [];
idx2_trim_2 = [];

for i = 1:length(idx1_trim)
    u = feat_dist(idx1_trim(i), :);
    [val_min, idx_min] = min(u);
    u(idx_min) = max(u);
    [val_2min, ~] = min(u);
    
    if (val_min / val_2min < 0.8) && (val_min < 0.8)
        idx1_trim_2 = [idx1_trim_2; idx1_trim(i)];
        idx2_trim_2 = [idx2_trim_2; idx2_trim(i)];
    end
end

idx1_final = idx1_trim_2;
idx2_final = idx2_trim_2;
idx_match = [idx1_final, idx2_final];

fprintf('Find %d matches.\n', length(idx1_final));
