function [lower, upper] = TestTIndepSamplesInterval(sample1, sample2, confidence)
%TestTIndepSamplesInterval Finds confidence intervals given a sample.
%   confidence: The desired probability that the true mean lies within

    n1 = max(size(sample1));
    n2 = max(size(sample2));
    df = n1 + n2 - 2;
    alpha = 1 - confidence;
    
    % Infer the standard deviation
    inferredStd = sqrt(InferredVarPooled(n1, SS(sample1), n2, SS(sample2)));
    
    delta = Mean(sample1) - Mean(sample2);
    stdErrorSqr1 = inferredStd^2 ./ n1;
    stdErrorSqr2 = inferredStd^2 ./ n2;
    stdErrorSqrDelta = stdErrorSqr1 + stdErrorSqr2;
    stdErrorDelta = sqrt(stdErrorSqrDelta);
    
    tCritical = tinv(1 - alpha / 2, df);
    
    lower = delta - tCritical * stdErrorDelta;
    upper = delta + tCritical * stdErrorDelta;
    
end

