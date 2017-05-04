function [result] = InferredStd(data, dim)
%InferredStd Gives inferred population standard devation based on given sample data.

    [n, maxDim] = max(size(data));
    if nargin < 2
        dim = maxDim;
    end
    
    result = sqrt(SS(data, dim) / (n - 1));
end