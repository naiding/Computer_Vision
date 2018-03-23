% ----------------------------------------------------------------------
% input: num_nodes x batch_size
% labels: batch_size x 1
% ----------------------------------------------------------------------

function [loss, dv_input] = loss_crossentropy(input, labels, hyper_params, backprop)

assert(max(labels) <= size(input,1));

% TODO: CALCULATE LOSS
% loss = 0;

[~, batch_size] = size(input);

idx = sub2ind(size(input), labels', 1:batch_size);
loss = sum(-log(input(idx))) / batch_size;

dv_input = zeros(size(input));
if backprop
	% TODO: BACKPROP CODE
    dv_input(idx) = -1 ./ input(idx);
%     dv_input = dv_input / batch_size;
end
 