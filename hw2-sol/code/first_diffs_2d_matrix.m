function diff_matrix = first_diffs_2d_matrix(m, n)

diff_matrix = zeros(2*m*n, m*n);
Dm = -eye(m) + circshift(eye(m), [0, 1]);
Dn = -eye(n) + circshift(eye(n), [0, 1]);

diff_matrix(1:m*n, 1:m*n) = kron(eye(n), Dm);
diff_matrix(m*n+1:2*m*n, 1:m*n) = kron(Dn, eye(m));
% 
% [m, n, d] = size(surfaceNormals); 
% dfdx = -surfaceNormals(:, :, 1) ./ surfaceNormals(:, :, 3);
% dfdy = -surfaceNormals(:, :, 2) ./ surfaceNormals(:, :, 3);
% A = first_diffs_2d_matrix(m, n);
% b = [dfdx(:); dfdy(:)];
% heightMap = pinv(A) * b;
% minVal = min(heightMap);
% heightMap = heightMap - minVal;
% heightMap = reshape(heightMap, m, n);