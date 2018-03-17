function arch = arch_design()

task_type = 'train';

conv1.size = 9;
conv1.num = 15;
conv1.depth = 1;

pool1.size = 2;
pool1.stride = 2;

fc.num_in = 1500;
fc.num_out = 10;

arch = [init_layer('conv',struct('filter_size',conv1.size,'filter_depth',conv1.depth,'num_filters',conv1.num))
        init_layer('pool',struct('filter_size',pool1.size,'stride',pool1.stride))
%         init_layer('relu',[])
        init_layer('leaky_relu',struct('leaky_rate',0.01))
        init_layer('flatten',struct('num_dims',4))
%         init_layer('dropout',struct('dropoutFraction',0.5,'task_type',task_type))
        init_layer('linear',struct('num_in', fc.num_in,'num_out',fc.num_out))
        init_layer('softmax',[])];

% conv1.size = 5;
% conv1.depth = 1;
% conv1.num = 32;
% 
% pool1.size = 2;
% pool1.stride = 2;
% 
% conv2.size = 5;
% conv2.depth = 32;
% conv2.num = 64;
% 
% pool2.size = 2;
% pool2.stride = 2;
% 
% fc1.num_in = 1024;
% fc1.num_out = 10;
% 
% arch = [init_layer('conv', struct('filter_size', conv1.size, 'filter_depth', conv1.depth, 'num_filters', conv1.num))
%         init_layer('relu',[])
%         init_layer('pool', struct('filter_size', pool1.size, 'stride', pool1.stride))
%         init_layer('conv', struct('filter_size', conv2.size, 'filter_depth', conv2.depth, 'num_filters', conv2.num))
%         init_layer('relu',[])
%         init_layer('pool', struct('filter_size', pool2.size, 'stride', pool2.stride))
%         init_layer('flatten', struct('num_dims', 4))
%         init_layer('dropout',struct('dropoutFraction',0.5,'task_type',task_type))
%         init_layer('linear', struct('num_in', fc1.num_in, 'num_out', fc1.num_out))
%         init_layer('softmax', [])];

end

