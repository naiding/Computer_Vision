function [grad] = calc_gradient(model, input, activations, dv_output)
% Calculate the gradient at each layer, to do this you need dv_output
% determined by your loss function and the activations of each layer.
% The loop of this function will look very similar to the code from
% inference, just looping in reverse.

num_layers = numel(model.layers);
grad = cell(num_layers,1);

activations = [{input}; activations];

% TODO: Determine the gradient at each layer with weights to be updated
for i = num_layers:-1:1
    layer = model.layers(i);
%     tic;
    [~, dv_output, grad{i}] = layer.fwd_fn(activations{i}, layer.params, layer.hyper_params, true, dv_output);
%     fprintf("backward %s used time %f. \n", layer.type, toc);

%     grad{i} = layer_grad;
%     dv_output = dv_input; 
end

% fprintf("------------------ \n");