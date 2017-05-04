function [result] = InferredVar(data, dim)
%InferredVar Gives inferred population variance based on given sample data.

    [n, maxDim] = max(size(data));
    if nargin < 2
        dim = maxDim;
    end

    result = SS(data, dim) / (n - 1);
end

