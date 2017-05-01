function [result] = Var(data, dim)
%Var Gives descriptive variance for data given

    [n, maxDim] = max(size(data));
    if nargin < 2
        dim = maxDim;
    end

    result = SS(data, dim) / n;
end

