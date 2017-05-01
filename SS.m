function [result] = SS(data, dim)
%SS Sum of squares

    [n, maxDim] = max(size(data));
    if nargin < 2
        dim = maxDim;
    end

    m = mean(data, dim);
    result = sum((data - m) .^ 2, dim);
end

