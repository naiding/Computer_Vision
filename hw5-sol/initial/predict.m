function [prediction, accuracy] = predict(model, data, label)

[final_output, ~] = inference(model, data);
[~, prediction] = max(final_output);
accuracy = sum(prediction==label') / length(label);

end

