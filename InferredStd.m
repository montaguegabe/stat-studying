function [result] = InferredStd(data)
%InferredStd Gives inferred population standard devation based on given sample data.

    n = max(size(data));
    result = sqrt(SS(data) / (n - 1));
end