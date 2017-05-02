function [power] = TestTPower(alpha, n, nullMean, altSign, realMean, realStd)
%TestTPower Gives the power of a t test given population stats
%   nullMean: Population mean if the null hypothesis is true
%   altSign:  For one-tailed test set to 0, otherwise set to 1 if
%   alternative mean is greater, or -1 if alternative mean is smaller.
%   realMean:  The actual mean
%   realStd:      Standard deviation of population
    
    % Calculate difference between null and real means in terms of t score
    standardError = realStd ./ sqrt(n);
    stdErrorsDifferent = (realMean - nullMean) ./ standardError;

    df = n - 1;
    
    if altSign == 0
        cutoffP = alpha ./ 2;
    else
        cutoffP = alpha;
    end
    
    % Decide by comparing to a critical value
    if all(stdErrorsDifferent >= 0)
        
        % Find the critical t value for the null hypothesis
        tCriticalNull = tinv(1 - cutoffP, df);
        
        % Convert to t value for alternative hypothesis and find the
        % probability
        tCriticalReal = tCriticalNull - stdErrorsDifferent;
        
        % To think about: Above, we do we still use the number of standard
        % errors between the two distribution means?
        
        power = 1 - tcdf(tCriticalReal, df);
        
    elseif all(stdErrorsDifferent < 0)
        
        % Find the critical t value for the null hypothesis
        tCriticalNull = tinv(cutoffP, df);
        
        % Convert to t value for alternative hypothesis and find the
        % probability
        tCriticalReal = abs(stdErrorsDifferent) - tCriticalNull;
        power = tcdf(tCriticalReal, df);
    else
        throw(MException('TESTTPOWER:MixedEffects', ...
        'Vector input with both positive and negative effects not supported here'));
    end
end

