function [output, dv_input, grad, params] = func_dropout(input, params, hyper_params, backprop, dv_output)

task = hyper_params.task_type;
dv_input = [];
grad = struct('W',[],'b',[]);

if strcmp(task, 'train')
    
    p = hyper_params.dropoutFraction;
    
    if ~backprop
        params.dropoutMask = (rand(size(input)) < p) / p;
        output = input .* params.dropoutMask;
    else
        output = input .* params.dropoutMask;
        dv_input = dv_output / p;
		dv_input(output == 0) = 0;
    end
elseif strcmp(task, 'test')
    output = input;
else
    output = input;
end