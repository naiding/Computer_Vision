function [accuracy] = predict(model, data, label)

[final_output, ~] = inference(model, data);
[~, pred] = max(final_output);
accuracy = sum(pred==label') / length(label);

end

