function [result] = Mean(data, dim)
%Mean Vector mean
    if nargin == 1
        result = mean(data);
    else
        result = mean(data, dim);
    end
end

