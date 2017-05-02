function [lower, upper] = TestTInterval(sample, confidence)
%TestTInterval Finds confidence intervals given a sample.
%   confidence: The desired probability that the true mean lies within

    n = max(size(sample));
    df = n - 1;
    alpha = 1 - confidence;
    
    % Infer the standard deviation
    inferredStd = InferredStd(sample);
    
    m = Mean(sample);
    stdError = inferredStd / sqrt(n);    
    tCritical = tinv(1 - alpha / 2, df);
    
    lower = m - tCritical * stdError;
    upper = m + tCritical * stdError;
    
end

