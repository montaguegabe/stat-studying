function [rejectNull, t, p, d] = TestTIndepSamples(sample1, sample2, ...
    alpha, altSign, nullMeanDelta)
%TestTIndepSamples Conducts an indep. T test for M1 - M2
%   altSign:  For one-tailed test set to 0, otherwise set to 1 if
%   alternative mean is greater, or -1 if alternative mean is smaller.
%   nullMean (optional): Mean difference under null hypothesis

    if nargin < 5
        nullMeanDelta = 0;
    end

    % Conduct hypothesis test    
    n1 = max(size(sample1));
    n2 = max(size(sample2));
    df = n1 + n2 - 2;
    
    % Infer the standard deviation
    inferredStd = sqrt(InferredVarPooled(n1, SS(sample1), n2, SS(sample2)));
    
    % Calculate statistic of our sample
    m1 = Mean(sample1);
    m2 = Mean(sample2);
    delta = m1 - m2;
    stdErrorSqr1 = inferredStd^2 ./ n1;
    stdErrorSqr2 = inferredStd^2 ./ n2;
    stdErrorSqrDelta = stdErrorSqr1 + stdErrorSqr2;
    stdErrorDelta = sqrt(stdErrorSqrDelta);
    
    t = (delta - nullMeanDelta) / stdErrorDelta;
    
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
        rejectNull = t < -tCritical;
    end
    
    % Estimate Cohen's d if we rejected the null hypothesis, otherwise we
    % shouldn't be estimating an effect size
    if rejectNull
        d = (delta - nullMeanDelta) / inferredStd;
    else
        % Return effect size of 0 or NaN - either one
        % d = NaN;
        d = 0;
    end
end

