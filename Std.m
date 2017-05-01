function [result] = Std(data, dim)
%Std Gives descriptive standard deviation for data given.

    [n, maxDim] = max(size(data));
    if nargin < 2
        dim = maxDim;
    end

    result = sqrt(SS(data, dim) / n);
end