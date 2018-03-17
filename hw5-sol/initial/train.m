function [model, loss_history] = train(model, input, label, val_input, val_label, params, numIters)

% Initialize training parameters
% This code sets default values in case the parameters are not passed in.

% Learning rate
if isfield(params,'learning_rate') 
    lr = params.learning_rate;
else
    lr = .01; 
end

% Weight decay
if isfield(params,'weight_decay') 
    wd = params.weight_decay;
else
    wd = .0005; 
end

% Batch size
if isfield(params,'batch_size') 
    batch_size = params.batch_size;
else
    batch_size = 128; 
end

% There is a good chance you will want to save your network model during/after
% training. It is up to you where you save and how often you choose to back up
% your model. By default the code saves the model in 'model.mat'
% To save the model use: save(save_file,'model');
if isfield(params,'save_file') 
    save_file = params.save_file;
else
    save_file = 'model.mat'; 
end

% update_params will be passed to your update_weights function.
% This allows flexibility in case you want to implement extra features like momentum.

method = 'nesterov'; % you can choose vanilla, momentum, nesterov, adam
update_params = struct('learning_rate',lr,'weight_decay',wd,'method',method);

for i = 1:numel(model.layers)
    layer = model.layers(i);
    
    if strcmp(method, 'momentum') || strcmp(method, 'nesterov')
        layer.params.vW = zeros(size(layer.params.W));
        layer.params.vb = zeros(size(layer.params.b));
    end
    
    if strcmp(method, 'adam')
        layer.params.mW = zeros(size(layer.params.W));
        layer.params.vW = zeros(size(layer.params.W));
        layer.params.mb = zeros(size(layer.params.b));
        layer.params.vb = zeros(size(layer.params.b));
    end
    
    if strcmp(layer.type, 'dropout')
        global dropoutMask; % for fn_dropout
    end
    
    model.layers(i) = layer;
end

num_data = length(label);
loss_history = [];
acc_input = [];
acc_val = [];

fprintf("Begin training process ... \n");

for i = 1:numIters
    rp = randperm(num_data);
    
    for j = 1 : batch_size : (num_data - batch_size + 1)
        X_batch = input(:, :, :, rp(j:j+batch_size-1));
        y_batch = label(rp(j:j+batch_size-1));
        
        [final_output, activations] = inference(model, X_batch);
        
        [loss, dv_input_loss] = loss_crossentropy(final_output, y_batch, [], true);
%         fprintf("Iter %d ... batch %d ... loss %f \n", i, j, loss);
        grad = calc_gradient(model, X_batch, activations, dv_input_loss);
        model = update_weights(model, grad, update_params);
    end
    
    [model, ~, acc1, loss_input] = predict(model, input, label);
    loss_history = [loss_history; loss_input];
    [model, ~, acc2, ~] = predict(model, val_input, val_label);
    acc_input = [acc_input; acc1];
    acc_val = [acc_val; acc2];
    
    fprintf(" --- Iter %d ... overall loss %f ... train acc %f ... val acc %f. --- \n", i, loss_input, acc1, acc2);

end

save(save_file,'model');

figure;
plot(acc_input), hold on
plot(acc_val), hold off
