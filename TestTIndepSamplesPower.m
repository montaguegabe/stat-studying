function [power] = TestTIndepSamplesPower(alpha, n1, n2, nullMeanDelta, ...
    altSign, realMean1, realStd1, realMean2, realStd2)
%TestTPower Gives the power of a indep. 2-sample t test
%   nullMeanDelta: Population mean difference if the null hypothesis is true
%   altSign:  For one-tailed test set to 0, otherwise set to 1 if
%   alternative mean is greater, or -1 if alternative mean is smaller.
%   realMean1/2:  The actual means
%   realStd1/2:   The actual standard deviations
    
    % Calculate difference between null and real means in terms of t score
    delta = realMean1 - realMean2;
    standardErrorDelta = sqrt(realStd1^2 ./ n1 + realStd2^2 ./ n2);
    stdErrorsDifferent = (delta - nullMeanDelta) ./ standardErrorDelta;

    df = n1 + n2 - 2;
    
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
        tCriticalReal = abs(stdErrorsDifferent) - abs(tCriticalNull);
        power = tcdf(tCriticalReal, df);
    else
        throw(MException('TESTTPOWER:MixedEffects', ...
        'Vector input with both positive and negative effects not supported here'));
    end
end

