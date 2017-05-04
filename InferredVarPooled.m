function [variance] = InferredVarPooled(n1, ss1, n2, ss2)
%InferredVarPooled Estimates population variance from two samples

    variance = (ss1 + ss2) ./ (n1 + n2 - 2);
end
