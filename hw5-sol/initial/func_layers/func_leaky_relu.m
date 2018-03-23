function [output, dv_input, grad, params] = func_leaky_relu(input, params, hyper_params, backprop, dv_output)

k = hyper_params.leaky_rate;

output = zeros(size(input));
output = input.*(input >= 0) + k.*input.*(input < 0);

dv_input = [];
grad = struct('W',[],'b',[]);

if backprop
    dv_input = zeros(size(input));
    dv_input = (1.*(input >= 0) + k.*(input < 0)) .* dv_output;
end