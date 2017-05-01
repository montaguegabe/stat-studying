function [power, effectSize] = TestZPower(alpha, n, nullMean, std, altSign, realMean)
%TestZPower Conducts a Z test given a sample.
%   nullMean: Population mean if the null hypothesis is true
%   std:      Standard deviation of population
%   altSign:  For one-tailed test set to 0, otherwise set to 1 if
%   alternative mean is greater, or -1 if alternative mean is smaller.
%   realMean:  The actual mean
    
    % Calculate statistic of our sample
    stdError = std / sqrt(n);
    
    stdErrorsDifferent = (realMean - nullMean) / stdError;

    if altSign == 0
        cutoffP = alpha / 2;
    else
        cutoffP = alpha;
    end
    
    % Decide by comparing to a critical value
    if stdErrorsDifferent >= 0
        
        % Find the z value for the null hypothesis
        zCriticalNull = norminv(1 - cutoffP, 0, 1);
        
        % Convert to z value for alternative hypothesis and find the
        % probability
        zCriticalReal = zCriticalNull - stdErrorsDifferent;
        power = 1 - normcdf(zCriticalReal);
        
    else
        
        % Find the z value for the null hypothesis
        zCriticalNull = norminv(cutoffP, 0, 1);
        
        % Convert to z value for alternative hypothesis and find the
        % probability
        zCriticalReal = abs(stdErrorsDifferent) - zCriticalNull;
        power = normcdf(zCriticalReal);
    end
    
    % Use the formula for effect size
    effectSize = abs(realMean - nullMean) / std;
end

