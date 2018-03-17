function [X_pca] = pca_process(X, num_eig)

assert(num_eig <= max(size(X)), 'Too many eigenvector number.');

X = X - mean(X);
cov = X'*X / size(X, 1);
[U, S, V] = svd(cov);
UT = U';
X_pca = X * U(:, 1:num_eig) * UT(1:num_eig, :);

end

