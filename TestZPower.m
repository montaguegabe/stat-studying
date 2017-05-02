function [power] = TestZPower(alpha, n, nullMean, std, altSign, realMean)
%TestZPower Gives the power of a z test given population stats
%   nullMean: Population mean if the null hypothesis is true
%   std:      Standard deviation of population
%   altSign:  For one-tailed test set to 0, otherwise set to 1 if
%   alternative mean is greater, or -1 if alternative mean is smaller.
%   realMean:  The actual mean
    
    % Calculate difference between null and real means in terms of z score
    standardError = std ./ sqrt(n);
    stdErrorsDifferent = (realMean - nullMean) ./ standardError;

    if altSign == 0
        cutoffP = alpha ./ 2;
    else
        cutoffP = alpha;
    end
    
    % Decide by comparing to a critical value
    if all(stdErrorsDifferent >= 0)
        
        % Find the critical z value for the null hypothesis
        zCriticalNull = norminv(1 - cutoffP, 0, 1);
        
        % Convert to z value for alternative hypothesis and find the
        % probability
        zCriticalReal = zCriticalNull - stdErrorsDifferent;
        power = 1 - normcdf(zCriticalReal);
        
    elseif all(stdErrorsDifferent < 0)
        
        % Find the critical z value for the null hypothesis
        zCriticalNull = norminv(cutoffP, 0, 1);
        
        % Convert to z value for alternative hypothesis and find the
        % probability
        zCriticalReal = abs(stdErrorsDifferent) - zCriticalNull;
        power = normcdf(zCriticalReal);
    else
        throw(MException('TESTZPOWER:MixedEffects', ...
        'Vector input with both positive and negative effects not supported here'));
    end
end

