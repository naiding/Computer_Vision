function [output, dv_input, grad, params] = func_bn(input, params, hyper_params, backprop, dv_output)

[~,~,num_channels,batch_size] = size(input);

out_height = size(input,1);
out_width = size(input,2);
output = zeros(out_height, out_width, num_channels, batch_size);

% take W and b as gamma and beta
% then W and b have size: num_channels * 1
% input has size: in_height x in_width x num_channels x batch_size
% for each channel: in_height x in_width x batch_size

dv_input = [];
grad = struct('W',[],'b',[]);

end

