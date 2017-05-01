function [result] = Z(x, mean, std)
%Z Gives the exact Z-score of a datapoint

    result = (x - mean) / std;
end

