function [rejectNull, t, p, d] = TestT(sample, alpha, nullMean, altSign)
%TestT Conducts a T test given a sample.
%   nullMean: Population mean if the null hypothesis is true
%   altSign:  For one-tailed test set to 0, otherwise set to 1 if
%   alternative mean is greater, or -1 if alternative mean is smaller.

    % Conduct hypothesis test
    
    n = max(size(sample));
    df = n - 1;
    
    % Infer the standard deviation
    inferredStd = InferredStd(sample);
    
    % Calculate statistic of our sample
    m = Mean(sample);
    stdError = inferredStd / sqrt(n); % <- here's the difference from a Z test!
    t = (m - nullMean) / stdError;
    
    % Return tail probability if one-sided, twice tail probability of
    % two-sided
    p = 1 - tcdf(abs(t), df);
    if altSign == 0
        p = p * 2;
    end

    % Decide by comparing to a critical value
    if altSign == 0
        tCritical = tinv(1 - alpha / 2, df);
        rejectNull = abs(t) > tCritical;
    elseif altSign == 1
        tCritical = tinv(1 - alpha, df);
        rejectNull = t > tCritical;
    else
        tCritical = tinv(1 - alpha, df);
        rejectNull = t < tCritical;
    end
    
    % Estimate Cohen's d if we rejected the null hypothesis, otherwise we
    % shouldn't be estimating an effect size
    if rejectNull
        d = (m - nullMean) / inferredStd;
    else
        % Return effect size of 0 or NaN - either one
        % d = NaN;
        d = 0;
    end
end

