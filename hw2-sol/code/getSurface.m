function  heightMap = getSurface(surfaceNormals, method)
% GETSURFACE computes the surface depth from normals
%   HEIGHTMAP = GETSURFACE(SURFACENORMALS, IMAGESIZE, METHOD) computes
%   HEIGHTMAP from the SURFACENORMALS using various METHODs. 
%  
% Input:
%   SURFACENORMALS: height x width x 3 array of unit surface normals
%   METHOD: the intergration method to be used
%
% Output:
%   HEIGHTMAP: height map of object

    [h, w, ~] = size(surfaceNormals); 
    dfdx = -surfaceNormals(:, :, 1) ./ surfaceNormals(:, :, 3);
    dfdy = -surfaceNormals(:, :, 2) ./ surfaceNormals(:, :, 3);

    heightMap = zeros(h, w);

    switch method
        case 'column'
            dfdx_sum = cumsum(dfdx, 2);
            dfdy_sum = repmat(cumsum(dfdy(:, 1)), 1, w);
            heightMap = dfdx_sum + dfdy_sum;
        case 'row'
            dfdx_sum = repmat(cumsum(dfdx(1, :)), h, 1);
            dfdy_sum = cumsum(dfdy);
            heightMap = dfdx_sum + dfdy_sum;
        case 'average'
            heightMap = 0.5 * (getSurface(surfaceNormals, 'column') + getSurface(surfaceNormals, 'row'));
        case 'random'
            for i = 1:w
                for j = 1:h
                    num_path = 2;
                    for k = 1:num_path
                        heightMap(j, i) = heightMap(j, i) + dfdx(1, 1) + dfdy(1, 1);
                        x_pos = 1; y_pos = 1;
                        while true
                            [x_pos, y_pos, x_shift, y_shift] = getNextPoint(x_pos, y_pos, i, j);
                            if x_shift + y_shift == 0
                                break;
                            else
                                heightMap(j, i) = heightMap(j, i) + x_shift*dfdx(y_pos, x_pos) + y_shift*dfdy(y_pos, x_pos);
                            end
                        end
                    end
                    heightMap(j, i) = heightMap(j, i) / num_path;
                end
            end
    end
end

function [next_x, next_y, x_shift, y_shift] = getNextPoint(current_x, current_y, final_x, final_y)
    if final_x == 1 && final_y == 1
        next_x = current_x;
        next_y = current_y;
    elseif final_x == 1 && final_y ~= 1
        next_x = 1;
        next_y = min(current_y + 1, final_y);
    elseif final_x ~= 1 && final_y == 1
        next_x = min(current_x + 1, final_x);
        next_y = 1;
    else
        if current_x == final_x && current_y == final_y
            next_x = current_x;
            next_y = current_y;
        elseif current_x == final_x && current_y ~= final_y
            next_x = final_x;
            next_y = min(current_y + 1, final_y);
        elseif current_x ~= final_x && current_y == final_y
            next_x = min(current_x + 1, final_x);
            next_y = final_y;
        else
            [dx, dy] = getRandomShift();
            next_x = current_x + dx;
            next_y = current_y + dy;
        end
    end
    
    x_shift = next_x - current_x;
    y_shift = next_y - current_y;
end

function [dx, dy] = getRandomShift()
    dx = unidrnd(2)-1;
    if dx == 0
        dy = 1;
    else
        dy = 0;
    end
end
