function arch = arch_design()

task_type = 'train';

% conv1.size = 9;
% conv1.num = 20;
% conv1.depth = 1;
% 
% pool1.size = 2;
% pool1.stride = 2;
% 
% fc.num_in = 2000;
% fc.num_out = 10;
% 
% arch = [init_layer('conv',struct('filter_size',conv1.size,'filter_depth',conv1.depth,'num_filters',conv1.num))
%         init_layer('pool',struct('filter_size',pool1.size,'stride',pool1.stride))
% %         init_layer('relu',[])
% %         init_layer('bn',[])
%         init_layer('leaky_relu',struct('leaky_rate',0.01))
%         init_layer('flatten',struct('num_dims',4))
%         init_layer('dropout',struct('dropoutFraction',0.5,'task_type',task_type))
%         init_layer('linear',struct('num_in', fc.num_in,'num_out',fc.num_out))
%         init_layer('softmax',[])];

% conv1.size = 5;
% conv1.depth = 1;
% conv1.num = 15;
% 
% pool1.size = 2;
% pool1.stride = 2;
% 
% conv2.size = 5;
% conv2.depth = 15;
% conv2.num = 20;
% 
% pool2.size = 2;
% pool2.stride = 2;
% 
% fc1.num_in = 320;
% fc1.num_out = 10;
% 
% arch = [init_layer('conv', struct('filter_size', conv1.size, 'filter_depth', conv1.depth, 'num_filters', conv1.num))
%         init_layer('leaky_relu',struct('leaky_rate',0.01))
%         init_layer('pool', struct('filter_size', pool1.size, 'stride', pool1.stride))
%         init_layer('conv', struct('filter_size', conv2.size, 'filter_depth', conv2.depth, 'num_filters', conv2.num))
%         init_layer('leaky_relu',struct('leaky_rate',0.01))
%         init_layer('pool', struct('filter_size', pool2.size, 'stride', pool2.stride))
%         init_layer('flatten', struct('num_dims', 4))
%         init_layer('dropout',struct('dropoutFraction',0.5,'task_type',task_type))
%         init_layer('linear', struct('num_in', fc1.num_in, 'num_out', fc1.num_out))
%         init_layer('softmax', [])];

% conv1.size = 5;
% conv1.depth = 1;
% conv1.num = 6;
% 
% pool1.size = 2;
% pool1.stride = 2;
% 
% conv2.size = 5;
% conv2.depth = 6;
% conv2.num = 16;
% 
% pool2.size = 2;
% pool2.stride = 2;
% 
% conv3.size = 3;
% conv3.depth = 16;
% conv3.num = 120;
% 
% fc1.num_in = 480;
% fc1.num_out = 10;
% 
% arch = [init_layer('conv', struct('filter_size', conv1.size, 'filter_depth', conv1.depth, 'num_filters', conv1.num))
%         init_layer('leaky_relu',struct('leaky_rate',0.01))
%         init_layer('pool', struct('filter_size', pool1.size, 'stride', pool1.stride))
%         init_layer('conv', struct('filter_size', conv2.size, 'filter_depth', conv2.depth, 'num_filters', conv2.num))
%         init_layer('leaky_relu',struct('leaky_rate',0.01))
%         init_layer('pool', struct('filter_size', pool2.size, 'stride', pool2.stride))
%         init_layer('conv', struct('filter_size', conv3.size, 'filter_depth', conv3.depth, 'num_filters', conv3.num))
%         init_layer('leaky_relu',struct('leaky_rate',0.01))
%         init_layer('flatten', struct('num_dims', 4))
%         init_layer('dropout',struct('dropoutFraction',0.5,'task_type',task_type))
%         init_layer('linear', struct('num_in', fc1.num_in, 'num_out', fc1.num_out))
%         init_layer('softmax', [])];

% without fc layer
% conv1.size = 5;
% conv1.depth = 1;
% conv1.num = 25;
% 
% pool1.size = 2;
% pool1.stride = 2;
% 
% conv2.size = 1;
% conv2.depth = 25;
% conv2.num = 15;
% 
% pool2.size = 2;
% pool2.stride = 2;
% 
% conv3.size = 5;
% conv3.depth = 15;
% conv3.num = 10;
% 
% pool3.size = 2;
% pool3.stride = 2;
%
% arch = [init_layer('conv', struct('filter_size', conv1.size, 'filter_depth', conv1.depth, 'num_filters', conv1.num))
%         init_layer('leaky_relu',struct('leaky_rate',0.01))
%         init_layer('pool', struct('filter_size', pool1.size, 'stride', pool1.stride))
%         init_layer('conv', struct('filter_size', conv2.size, 'filter_depth', conv2.depth, 'num_filters', conv2.num))
%         init_layer('leaky_relu',struct('leaky_rate',0.01))
%         init_layer('pool', struct('filter_size', pool2.size, 'stride', pool2.stride))
%         init_layer('conv', struct('filter_size', conv3.size, 'filter_depth', conv3.depth, 'num_filters', conv3.num))
%         init_layer('leaky_relu',struct('leaky_rate',0.01))
%         init_layer('pool', struct('filter_size', pool3.size, 'stride', pool3.stride))
%         init_layer('flatten', struct('num_dims', 4))
%         init_layer('softmax', [])];

% with fc layer
% conv1.size = 5;
% conv1.depth = 1;
% conv1.num = 25;
% 
% pool1.size = 2;
% pool1.stride = 2;
% 
% conv2.size = 1;
% conv2.depth = 25;
% conv2.num = 15;
% 
% pool2.size = 2;
% pool2.stride = 2;
% 
% conv3.size = 5;
% conv3.depth = 15;
% conv3.num = 10;
% 
% pool3.size = 2;
% pool3.stride = 2;
% 
% fc1.num_in = 10;
% fc1.num_out = 10;
% 
% arch = [init_layer('conv', struct('filter_size', conv1.size, 'filter_depth', conv1.depth, 'num_filters', conv1.num))
%         init_layer('leaky_relu',struct('leaky_rate',0.01))
%         init_layer('pool', struct('filter_size', pool1.size, 'stride', pool1.stride))
%         init_layer('conv', struct('filter_size', conv2.size, 'filter_depth', conv2.depth, 'num_filters', conv2.num))
%         init_layer('leaky_relu',struct('leaky_rate',0.01))
%         init_layer('pool', struct('filter_size', pool2.size, 'stride', pool2.stride))
%         init_layer('conv', struct('filter_size', conv3.size, 'filter_depth', conv3.depth, 'num_filters', conv3.num))
%         init_layer('leaky_relu',struct('leaky_rate',0.01))
%         init_layer('pool', struct('filter_size', pool3.size, 'stride', pool3.stride))
%         init_layer('flatten', struct('num_dims', 4))
%         init_layer('linear', struct('num_in', fc1.num_in, 'num_out', fc1.num_out))
%         init_layer('softmax', [])];

%% with one more 1*1 conv
% non-zero bias
conv1.size = 5;
conv1.depth = 1;
conv1.num = 32;

pool1.size = 2;
pool1.stride = 2;

conv2.size = 1;
conv2.depth = 32;
conv2.num = 16;

pool2.size = 2;
pool2.stride = 2;

conv3.size = 5;
conv3.depth = 16;
conv3.num = 64;

pool3.size = 2;
pool3.stride = 2;

conv4.size = 1;
conv4.depth = 64;
conv4.num = 10;

arch = [init_layer('conv', struct('filter_size', conv1.size, 'filter_depth', conv1.depth, 'num_filters', conv1.num))
        init_layer('leaky_relu',struct('leaky_rate',0.2))
        init_layer('pool', struct('filter_size', pool1.size, 'stride', pool1.stride))
        init_layer('conv', struct('filter_size', conv2.size, 'filter_depth', conv2.depth, 'num_filters', conv2.num))
        init_layer('leaky_relu',struct('leaky_rate',0.2))
        init_layer('pool', struct('filter_size', pool2.size, 'stride', pool2.stride))
        init_layer('conv', struct('filter_size', conv3.size, 'filter_depth', conv3.depth, 'num_filters', conv3.num))
        init_layer('leaky_relu',struct('leaky_rate',0.2))
        init_layer('pool', struct('filter_size', pool3.size, 'stride', pool3.stride))
        init_layer('conv', struct('filter_size', conv4.size, 'filter_depth', conv4.depth, 'num_filters', conv4.num))
        init_layer('leaky_relu',struct('leaky_rate',0.2))
        init_layer('flatten', struct('num_dims', 4))
        init_layer('softmax', [])];

%% change to 3x3
% 
% conv1.size = 3;
% conv1.depth = 1;
% conv1.num = 32;
% 
% conv2.size = 1;
% conv2.depth = 32;
% conv2.num = 16;
% 
% conv3.size = 3;
% conv3.depth = 16;
% conv3.num = 32;
% 
% pool3.size = 2;
% pool3.stride = 2;
% 
% conv4.size = 1;
% conv4.depth = 32;
% conv4.num = 16;
% 
% pool4.size = 2;
% pool4.stride = 2;
% 
% conv5.size = 3;
% conv5.depth = 16;
% conv5.num = 64;
% 
% conv6.size = 1;
% conv6.depth = 64;
% conv6.num = 32;
% 
% conv7.size = 3;
% conv7.depth = 32;
% conv7.num = 64;
% 
% pool7.size = 2;
% pool7.stride = 2;
% 
% conv8.size = 1;
% conv8.depth = 64;
% conv8.num = 10;
% 
% arch = [init_layer('conv', struct('filter_size', conv1.size, 'filter_depth', conv1.depth, 'num_filters', conv1.num))
%         init_layer('leaky_relu',struct('leaky_rate',0.02))
%         init_layer('conv', struct('filter_size', conv2.size, 'filter_depth', conv2.depth, 'num_filters', conv2.num))
%         init_layer('leaky_relu',struct('leaky_rate',0.02))
%         init_layer('conv', struct('filter_size', conv3.size, 'filter_depth', conv3.depth, 'num_filters', conv3.num))
%         init_layer('leaky_relu',struct('leaky_rate',0.02))
%         init_layer('pool', struct('filter_size', pool3.size, 'stride', pool3.stride))
%         init_layer('conv', struct('filter_size', conv4.size, 'filter_depth', conv4.depth, 'num_filters', conv4.num))
%         init_layer('leaky_relu',struct('leaky_rate',0.02))
%         init_layer('pool', struct('filter_size', pool4.size, 'stride', pool4.stride))
%         init_layer('conv', struct('filter_size', conv5.size, 'filter_depth', conv5.depth, 'num_filters', conv5.num))
%         init_layer('leaky_relu',struct('leaky_rate',0.02))
%         init_layer('conv', struct('filter_size', conv6.size, 'filter_depth', conv6.depth, 'num_filters', conv6.num))
%         init_layer('leaky_relu',struct('leaky_rate',0.02))
%         init_layer('conv', struct('filter_size', conv7.size, 'filter_depth', conv7.depth, 'num_filters', conv7.num))
%         init_layer('leaky_relu',struct('leaky_rate',0.02))
%         init_layer('pool', struct('filter_size', pool7.size, 'stride', pool7.stride))
%         init_layer('conv', struct('filter_size', conv8.size, 'filter_depth', conv8.depth, 'num_filters', conv8.num))
%         init_layer('leaky_relu',struct('leaky_rate',0.02))
%         init_layer('flatten', struct('num_dims', 4))
%         init_layer('softmax', [])];

end

