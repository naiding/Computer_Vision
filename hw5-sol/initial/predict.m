function [model, prediction, accuracy, loss] = predict(model, data, label)

for i = 1:numel(model.layers)
    if isfield(model.layers(i).type, 'dropout')
        model.layers(i).hyper_params.task_type = 'test';
        break;
    end
end

[model, final_output, ~] = inference(model, data);
[loss, ~] = loss_crossentropy(final_output, label, [], false);

[~, prediction] = max(final_output);
accuracy = sum(prediction==label') / length(label);

model.layers(i).hyper_params.task_type = 'train';

end

