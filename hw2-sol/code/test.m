% clear all
% clc
% M = rand(2000,2000);            % ����һ���������
% tic
% [A1,B1] = eig(M);                    % ���������������ֵ����������
% t1=toc
%  
% tic
% M = single(M);                     % ������ת��Ϊ��������
% M = gpuArray(M);                % �����ݴ�CPU�аᵽGPU
% [A2,B2] = eig(M);                 % ������ֵ����������
% A2 = gather(A2);                 % �����ݴ�GPU�аᵽCPU
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