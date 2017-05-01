function [result] = DistrToData(distr)
%DistrToData Distribution to data.

    values = 1:max(size(distr));
    result = cell2mat(arrayfun(@(x,y) repmat(y, 1, round(x)), distr, values, 'un', 0));
end

