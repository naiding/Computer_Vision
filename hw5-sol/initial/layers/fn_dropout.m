function [output, dv_input, grad] = fn_dropout(input, params, hyper_params, backprop, dv_output)

task = hyper_params.task_type;
dv_input = [];
grad = struct('W',[],'b',[]);

if strcmp(task, 'train')
    
    global dropoutMask;
    p = hyper_params.dropoutFraction;
    
    if ~backprop
        dropoutMask = (rand(size(input)) < p) / p;
        output = input .* dropoutMask;
    else
        output = input .* dropoutMask;
        dv_input = dv_output ./ p;
		dv_input(output == 0) = 0;
    end
elseif strcmp(task, 'test')
    output = input;
else
    output = input;
end

