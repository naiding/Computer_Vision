% Basic script to create a new network model

addpath layers;

l = [init_layer('conv',struct('filter_size',2,'filter_depth',3,'num_filters',2))
	init_layer('pool',struct('filter_size',2,'stride',2))
	init_layer('relu',[])
	init_layer('flatten',struct('num_dims',4))
	init_layer('linear',struct('num_in',32,'num_out',10))
	init_layer('softmax',[])];

model = init_model(l,[10 10 3],10,true);

% Example calls you might make:
% [output,~] = inference(model,input);
% [loss,~] = loss_euclidean(output,ground_truth,[],false);


% conv1.size = 9;
% conv1.num = 15;
% conv1.depth = im_dep;
% 
% pool1.size = 2;
% pool1.stride = 2;
% 
% num_output = 10;

% l = [init_layer('conv',struct('filter_size',conv1.size,'filter_depth',conv1.depth,'num_filters',conv1.num))
% 	init_layer('pool',struct('filter_size',pool1.size,'stride',pool1.stride))
% 	init_layer('relu',[])
% 	init_layer('flatten',struct('num_dims',4))
% 	init_layer('linear',struct('num_in', 10*10*conv1.num,'num_out',num_output))
% 	init_layer('softmax',[])];
% 
% model = init_model(l, [im_col im_row im_dep], num_output, true);
