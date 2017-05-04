function [rejectNull, z, p, d] = TestZ(sample, alpha, nullMean, std, altSign)
%TestZ Conducts a Z test given a sample.
%   nullMean: Population mean if the null hypothesis is true
%   std:      Standard deviation of population
%   altSign:  For one-tailed test set to 0, otherwise set to 1 if
%   alternative mean is greater, or -1 if alternative mean is smaller.

    n = max(size(sample));
    
    % Calculate statistic of our sample
    m = Mean(sample);
    stdError = std / sqrt(n);
    z = Z(m, nullMean, stdError);
    
    % Return tail probability if one-sided, twice tail probability of
    % two-sided
    p = 1 - normcdf(abs(z));
    if altSign == 0
        p = p * 2;
    end

    % Decide by comparing to a critical value
    if altSign == 0
        zCritical = norminv(1 - alpha / 2, 0, 1);
        rejectNull = abs(z) > zCritical;
    elseif altSign == 1
        zCritical = norminv(1 - alpha, 0, 1);
        rejectNull = z > zCritical;
    else
        zCritical = norminv(1 - alpha, 0, 1);
        rejectNull = z < -zCritical;
    end
    
    % Estimate Cohen's d if we rejected the null hypothesis, otherwise we
    % shouldn't be estimating an effect size
    if rejectNull
        d = (m - nullMean) / std;
    else
        % Return effect size of 0 or NaN - either one
        % d = NaN;
        d = 0;
    end
end

