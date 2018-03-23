function [model, output, activations] = inference(model, input)
% Do forward propagation through the network to get the activation
% at each layer, and the final output

num_layers = numel(model.layers);
activations = cell(num_layers,1);

% TODO: FORWARD PROPAGATION CODE

for i = 1:num_layers
    layer = model.layers(i);
%     tic;
    [activations{i}, ~, ~, model.layers(i).params] = layer.fwd_fn(input, layer.params, layer.hyper_params, false, []);
%     fprintf("forward %s used time %f. \n", layer.type, toc);
    input = activations{i};
%     fprintf(" ... %s layer output ... \n", layer.type);
%     size(input)
end

% fprintf("------------------ \n");

output = activations{end};