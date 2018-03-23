clc
clear

%% load data and create a toy data set for testing
load_MNIST_data;

% rng(0);

num_train_data = 60000;
rp = randperm(size(train_data, 4));
train_data = train_data(:, :, :, rp(1:num_train_data));
train_label = train_label(rp(1:num_train_data));

num_test_data = 10000;
trp = randperm(size(test_data, 4));
test_data = test_data(:, :, :, trp(1:num_test_data));
test_label = test_label(trp(1:num_test_data));

%% network setting
[im_col, im_row, im_dep, ~] = size(train_data);

addpath layers;
addpath func_layers;

num_output = 10;
l = arch_design();
model = init_model(l, [im_col im_row im_dep], num_output, true);

numIters = 30;
params.learning_rate = 0.003;
params.weight_decay = 0.0005;
params.batch_size = 100;
params.save_file = 'model_autosave.mat';

[model, loss_history] = train(model, train_data, train_label, test_data, test_label, params, numIters);
% [~, prediction, accuracy, ~] = predict(model, test_data, test_label);
% figure;plot(loss_history)
% accuracy
