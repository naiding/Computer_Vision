function updated_model = update_weights(model,grad,hyper_params)

num_layers = length(grad);
a = hyper_params.learning_rate;
lmda = hyper_params.weight_decay;
t = hyper_params.iteration;
updated_model = model;


% TODO: Update the weights of each layer in your model based on the calculated gradients
if isfield(hyper_params,'method') 
    method = hyper_params.method;
else
    method = 'vanilla'; 
end

switch method
    case 'vanilla'
        for i = 1:num_layers
            layer = updated_model.layers(i);
            layer.params.W = (1-lmda).*layer.params.W - a.*grad{i}.W;
            layer.params.b = (1-lmda).*layer.params.b - a.*grad{i}.b;
            updated_model.layers(i) = layer;
        end
    case 'momentum'
        mu = 0.9;
        for i = 1:num_layers
            layer = updated_model.layers(i);
            layer.params.vW = mu * layer.params.vW - a.*grad{i}.W;
            layer.params.vb = mu * layer.params.vb - a.*grad{i}.b;
            layer.params.W = (1-lmda).*layer.params.W + layer.params.vW;
            layer.params.b = (1-lmda).*layer.params.b + layer.params.vb;
            updated_model.layers(i) = layer;
        end
    case 'nesterov'
        mu = 0.9;
        for i = 1:num_layers
            layer = updated_model.layers(i);
            vW_pre = layer.params.vW;
            vb_pre = layer.params.vb;
            layer.params.vW = mu * vW_pre - a.*grad{i}.W;
            layer.params.vb = mu * vb_pre - a.*grad{i}.b;
            layer.params.W = layer.params.W + (-mu*vW_pre) + (1+mu)*layer.params.vW;
            layer.params.b = layer.params.b + (-mu*vb_pre) + (1+mu)*layer.params.vb;
            updated_model.layers(i) = layer;
        end
    case 'RMSprop'
        decay_rate = 0.99; eps = 1e-6;
        for i = 1:num_layers
            layer = updated_model.layers(i);
            
            layer.params.cacheW = decay_rate * layer.params.cacheW + (1-decay_rate) * (grad{i}.W .* grad{i}.W);
            layer.params.W = layer.params.W - a * grad{i}.W ./ (sqrt(layer.params.cacheW) + eps);
            
            layer.params.cacheb = decay_rate * layer.params.cacheb + (1-decay_rate) * (grad{i}.b .* grad{i}.b);
            layer.params.b = layer.params.b - a * grad{i}.b ./ (sqrt(layer.params.cacheb) + eps);
            
            updated_model.layers(i) = layer;
        end
        
    case 'adam'
        eps = 1e-6;
        beta1 = 0.9; beta2 = 0.999;
        for i = 1:num_layers
            layer = updated_model.layers(i);
            layer.params.mW = beta1*layer.params.mW + (1-beta1)*grad{i}.W;
            mtW = layer.params.mW / (1-power(beta1, t));
            layer.params.vW = beta2*layer.params.vW + (1-beta2)*(grad{i}.W .* grad{i}.W);
            vtW = layer.params.vW / (1-power(beta2, t));
            layer.params.W = layer.params.W - a * mtW ./ (sqrt(vtW) + eps);
            
            layer.params.mb = beta1*layer.params.mb + (1-beta1)*grad{i}.b;
            mtb = layer.params.mb / (1-power(beta1, t));
            layer.params.vb = beta2*layer.params.vb + (1-beta2)*(grad{i}.b .* grad{i}.b);
            vtb = layer.params.vb / (1-power(beta2, t));
            layer.params.b = layer.params.b - a * mtb ./ (sqrt(vtb) + eps);
  
            updated_model.layers(i) = layer;
        end
        
end

