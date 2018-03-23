% ----------------------------------------------------------------------
% input: num_nodes x batch_size
% output: num_nodes x batch_size
% ----------------------------------------------------------------------

function [output, dv_input, grad, params] = func_softmax(input, params, hyper_params, backprop, dv_output)

[num_classes, batch_size] = size(input);
% output = zeros(num_classes, batch_size);
% TODO: FORWARD CODE

exp_input = exp(input);
output = exp_input ./ sum(exp_input, 1);

dv_input = [];

% This is included to maintain consistency in the return values of layers,
% but there is no gradient to calculate in the softmax layer since there
% are no weights to update.
grad = struct('W',[],'b',[]); 

if backprop
	dv_input = zeros(size(input));
	% TODO: BACKPROP CODE
    
    for batch = 1 : batch_size
        jcb1 = repmat(output(:, batch)', num_classes, 1);
        jcb2 = jcb1' - eye(num_classes);
        jcb = -jcb1 .* jcb2;
        
        dv_input(:, batch) = jcb' * dv_output(:, batch);
    end
end
