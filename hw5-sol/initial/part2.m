clc
clear

%% load data and create a toy data set for testing
load_MNIST_data;

% rng(0);
rp = randperm(size(train_data, 4));

num_train_data = 2000;
num_val_data = 1000;

val_data = train_data(:, :, :, rp((num_train_data+1):(num_train_data+num_val_data)));
val_label = train_label(rp((num_train_data+1):(num_train_data+num_val_data)));

train_data = train_data(:, :, :, rp(1:num_train_data));
train_label = train_label(rp(1:num_train_data));

num_test_data = 10000;
trp = randperm(size(test_data, 4));
test_data = test_data(:, :, :, trp(1:num_test_data));
test_label = test_label(trp(1:num_test_data));

%% network setting
[im_col, im_row, im_dep, ~] = size(train_data);

addpath layers;

num_output = 10;
l = arch_design();
model = init_model(l, [im_col im_row im_dep], num_output, true);

numIters = 50;
params.learning_rate = 0.008 ;
params.weight_decay = 0.0005;
params.batch_size = 100;

[model, loss_history] = train(model, train_data, train_label, val_data, val_label, params, numIters);
[~, prediction, accuracy, ~] = predict(model, test_data, test_label);
figure;plot(loss_history)
accuracy

%% cross validation
% lrs = [0.01, 0.02, 0.03];
% wds = [0.0001, 0.0005, 0.00075, 0.001];
% 
% accuracies = zeros(length(lrs), length(wds));
% loss_list = [];
% 
% for i = 1:length(lrs)
%     for j = 1:length(wds)
%         
%         fprintf("lr = %f, wd = %f ... \n", lrs(i), wds(j));
%         
%         params.learning_rate = lrs(i);
%         params.weight_decay = wds(j);
%         params.batch_size = 256;
%         tic
%         [model, loss_history] = train(model, train_data, train_label, params, numIters);
%         toc
%         [prediction, accuracy] = predict(model, test_data, test_label);
%         accuracies(i, j) = accuracy;
%         loss_list = [loss_list, loss_history];
%         
%     end
% end