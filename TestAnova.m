function [rejectNull, f, p, msBetween, msWithin] = TestAnova(samples, sampleSizes, alpha)
%TestAnova Conducts an ANOVA test given a sample.

    bigN = sum(sampleSizes);
    levels = size(samples, 2);
    
    assert(levels == numel(sampleSizes));
    
    % Calculate F from samples
    samplesCombined = reshape(samples, [bigN, 1]);
    assert(numel(samples) == numel(samplesCombined));
    
    ssTotal = SS(samplesCombined);
    ssBetween = Mean(sampleSizes) * SS(Mean(samples, 1)); % not covered in lecture but important
    ssWithin = sum(SS(samples, 1));
    % assert(ssBetween + ssWithin == ssTotal); fails due to miniscule
    % rounding error
    
    dfTotal = bigN - 1;
    dfBetween = levels - 1;
    dfWithin = sum(sampleSizes - 1);
    assert(dfWithin + dfBetween == dfTotal);
    
    msBetween = ssBetween / dfBetween;
    msWithin = ssWithin / dfWithin;
    
    f = msBetween / msWithin;
    fCritical = finv(1 - alpha, dfBetween, dfWithin);
    
    p = 1 - fcdf(f, dfBetween, dfWithin);
    
    if f > fCritical
        rejectNull = true;
    else
        rejectNull = false;
    end
end

