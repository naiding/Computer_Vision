function [output, dv_input, grad, params] = func_pool(input, params, hyper_params, backprop, dv_output)

filter_size = hyper_params.filter_size;
stride = hyper_params.stride;
[~, ~, num_filters, batch_size] = size(input);

assert(mod(size(input,1) - filter_size, stride)==0, sprintf('Unsuitable stride and filter size'));

out_height = (size(input,1) - filter_size) / stride + 1;
out_width = (size(input,2) - filter_size) / stride + 1;

output = zeros(out_height, out_width, num_filters, batch_size);

% TODO: FORWARD CODE
for i = 1:out_height
    for j = 1:out_width
        output(i, j, :, :) = max(max(input( (i-1)*filter_size+1 : i*filter_size, (j-1)*filter_size+1 : j*filter_size, :, : )));
    end
end

% pool_filter = ones(filter_size) / filter_size^2;
% conv_idx = 1 : dim_pool : conv_dim-dim_pool+1;

dv_input = [];
grad = struct('W',[],'b',[]);

if backprop
	dv_input = zeros(size(input));
    
    for i = 1 : out_height
        for j = 1 : out_width
            for k = 1 : num_filters
                patch = input( (i-1)*filter_size+1 : i*filter_size, (j-1)*filter_size+1 : j*filter_size, k, : );
                [~, index] = matrix_max(patch);
                tt = zeros(size(patch));
                tt(sub2ind(size(tt), index(1,:), index(2,:), ones(1,batch_size), 1:batch_size)) = dv_output(i, j, k, :);
                dv_input((i-1)*filter_size+1 : i*filter_size, (j-1)*filter_size+1 : j*filter_size, k, :) = tt;
            end
        end
    end

	% TODO: BACKPROP CODE
%     for i = 1 : out_height
%         for j = 1 : out_width
%             for k = 1 : num_filters
%                 for l = 1 : batch_size
%                     [x, y] = ind2sub(size(input( (i-1)*filter_size+1 : i*filter_size, (j-1)*filter_size+1 : j*filter_size, k, l)), ...
%                         find(input((i-1)*filter_size+1 : i*filter_size, (j-1)*filter_size+1 : j*filter_size, k, l) ==  output(i, j, k, l)));
%                     dv_input((i-1)*filter_size+x, (j-1)*filter_size+y, k, l) = dv_output(i, j, k, l);
%                 end
%             end
%         end
%     end

end


