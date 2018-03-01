% clear all
% clc
% M = rand(2000,2000);            % 生成一个随机矩阵
% tic
% [A1,B1] = eig(M);                    % 求该随机矩阵的特征值和特征向量
% t1=toc
%  
% tic
% M = single(M);                     % 将数据转换为单精度型
% M = gpuArray(M);                % 将数据从CPU中搬到GPU
% [A2,B2] = eig(M);                 % 求特征值和特征向量
% A2 = gather(A2);                 % 将数据从GPU中搬到CPU
% t2 = toc
clear 
close all
w = 64; h = 64;
heightMap = zeros(h, w);
x_pos = 1; y_pos = 1;
i = 34; j = 45;
while true
    x_shift = unidrnd(2)-1;
    y_shift = unidrnd(2)-1;
    if x_pos >= i && y_pos >= j 
        break; 
    end

    if x_pos + x_shift > w x_shift = 0; end
    if y_pos + y_shift > h y_shift = 0; end


    x_pos = x_pos + x_shift;
    y_pos = y_pos + y_shift;
    heightMap(y_pos, x_pos) = 1;
end
imagesc(heightMap)