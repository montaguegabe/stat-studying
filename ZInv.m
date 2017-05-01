function [result] = ZInv(z, mean, std)
%ZInv Gives the exact datapoint corresponding to a z score, mean, and
%standard deviation.

    result = mean + z * std;
end

