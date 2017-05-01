function [result] = DistrSkewed(samples, mean, std, skew)
%DistrSkewed Draws samples from a normal distribution
    
    if nargin < 4
        skew = 0;
    end
    
    result = pearsrnd(mean, std, skew, 3, samples, 1);
end

