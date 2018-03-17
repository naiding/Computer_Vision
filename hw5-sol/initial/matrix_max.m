function [val, index] = matrix_max(A)

[val_row, ind_row] = max(A);
[val_col, ind_col] = max(val_row);

val = val_col;
ind_row = squeeze(ind_row);
ind_col = squeeze(ind_col);

index = [ind_row(sub2ind(size(ind_row), ind_col', 1:size(ind_row, 2))); ind_col'];

end

