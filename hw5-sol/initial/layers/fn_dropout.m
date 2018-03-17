function [output, dv_input, grad] = fn_dropout(input, params, hyper_params, backprop, dv_output)

global dropoutMask;
p = hyper_params.dropoutFraction;

dv_input = [];
grad = struct('W',[],'b',[]);

if isfield(hyper_params, 'train')
    if ~backprop
        dropoutMask = (rand(size(input)) < p) / p;
        output = input .* dropoutMask;
    else
        output = input .* dropoutMask;
        dv_input = dv_output;
		dv_input(output == 0) = 0;
    end
elseif isfield(hyper_params, 'test')
    output = input .* p;
else
    output = input;
end

