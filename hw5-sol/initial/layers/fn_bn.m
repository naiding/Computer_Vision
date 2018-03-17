function [output, dv_input, grad] = fn_bn(input, params, hyper_params, backprop, dv_output)

[~,~,num_channels,batch_size] = size(input);

out_height = size(input,1);
out_width = size(input,2);
output = zeros(out_height, out_width, num_channels, batch_size);

% take W and b as gamma and beta
% then W and b have size: num_channels * 1
% input has size: in_height x in_width x num_channels x batch_size
% for each channel: in_height x in_width x batch_size

x_hat = zeros(size(input));
x_mean = squeeze(mean(mean(mean(input, 4), 2), 1));
x_var = squeeze(var(var(var(input, 1, 4), 1, 2), 1, 1));
for i = 1:num_channels
    
end

dv_input = [];
grad = struct('W',[],'b',[]);

end

