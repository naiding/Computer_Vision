% ----------------------------------------------------------------------
% input: in_height x in_width x num_channels x batch_size
% output: out_height x out_width x num_filters x batch_size
% hyper parameters: (stride, padding for further work)
% params.W: filter_height x filter_width x filter_depth x num_filters
% params.b: num_filters x 1
% dv_output: same as output
% dv_input: same as input
% grad.W: same as params.W
% grad.b: same as params.b
% ----------------------------------------------------------------------

function [output, dv_input, grad] = fn_conv(input, params, hyper_params, backprop, dv_output)

[in_height,in_width,num_channels,batch_size] = size(input);
[filter_height,filter_width,filter_depth,num_filters] = size(params.W);
assert(filter_depth == num_channels, 'Filter depth does not match number of input channels');

out_height = size(input,1) - size(params.W,1) + 1;
out_width = size(input,2) - size(params.W,2) + 1;
output = zeros(out_height, out_width, num_filters, batch_size);
% TODO: FORWARD CODE

for batch = 1:batch_size
    for filterNum = 1:num_filters
        
        W = params.W(:, :, :, filterNum);
        b = params.b(filterNum);
        
        for channel = 1:num_channels
            output(:, :, filterNum, batch) = output(:, :, filterNum, batch) + ...
                    conv2(input(:, :, channel, batch), W(:, :, channel), 'valid');
        end
        
        output(:, :, filterNum, batch) = output(:, :, filterNum, batch) + b;
    end
end

dv_input = [];
grad = struct('W',[],'b',[]);

if backprop
	dv_input = zeros(size(input));
	grad.W = zeros(size(params.W));
	grad.b = zeros(size(params.b));
	% TODO: BACKPROP CODE
    for batch = 1:batch_size 
        for channel = 1:num_channels
            for filterNum = 1:num_filters
                dv_input(:,:,channel,batch) = dv_input(:,:,channel,batch) + ...
                  conv2(dv_output(:,:,filterNum,batch),rot90(params.W(:,:,channel,filterNum),2),'full');
            end
        end
    end
    
    for filterNum = 1:num_filters
        for channel = 1:num_channels
            grad.W(:,:,channel,filterNum) = zeros(filter_height, filter_width);
            for batch = 1:batch_size
                grad.W(:,:,channel,filterNum) = grad.W(:,:,channel,filterNum) + ... 
                    conv2(rot90(input(:,:,channel,batch),2),dv_output(:,:,filterNum,batch),'valid');
            end
        end
    end
    
    grad.b = squeeze(sum(sum(sum(dv_output,1),2),4));
end
