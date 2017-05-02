function [lower, upper] = TestZInterval(sample, confidence, std)
%TestZInterval Finds confidence intervals given a sample.
%   confidence: The desired probability that the true mean lies within
%   std:        Poplation standard deviation

    n = max(size(sample));
    alpha = 1 - confidence;
    
    m = Mean(sample);
    stdError = std / sqrt(n);    
    zCritical = norminv(1 - alpha / 2, 0, 1);
    
    lower = m - zCritical * stdError;
    upper = m + zCritical * stdError;
    
end

