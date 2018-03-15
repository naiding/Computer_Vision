clc
clear

%% load data and create a toy data set for testing
load_MNIST_data;

rng(0);
rp = randperm(size(train_data, 4));

num_train_data = 6000;
train_data = train_data(:, :, :, rp(1:num_train_data));
train_label = train_label(rp(1:num_train_data));

num_test_data = 1000;
trp = randperm(size(test_data, 4));
test_data = test_data(:, :, :, trp(1:num_test_data));
test_label = test_label(trp(1:num_test_data));

%% network setting
[im_col, im_row, im_dep, ~] = size(train_data);

addpath layers;

conv1.size = 9;
conv1.num = 15;
conv1.depth = im_dep;

pool1.size = 2;
pool1.stride = 2;

num_output = 10;

l = [init_layer('conv',struct('filter_size',conv1.size,'filter_depth',conv1.depth,'num_filters',conv1.num))
	init_layer('pool',struct('filter_size',pool1.size,'stride',pool1.stride))
	init_layer('relu',[])
	init_layer('flatten',struct('num_dims',4))
	init_layer('linear',struct('num_in', 10*10*conv1.num,'num_out',num_output))
	init_layer('softmax',[])];

model = init_model(l, [im_col im_row im_dep], num_output, true);

numIters = 2;
params.learning_rate = 0.01;
params.weight_decay = 0.0005;
params.batch_size = 100;

% [output, activations] = inference(model, train_data);
% [grad] = calc_gradient(model, train_data, activations, ones(size(output)));
% [grad_] = calc_gradient_(model, train_data, activations, ones(size(output)));

[model, loss_history] = train(model, train_data, train_label, params, numIters);
