function [result] = InferredVar(data)
%InferredVar Gives inferred population variance based on given sample data.

    n = max(size(data));
    result = SS(data) / (n - 1);
end

