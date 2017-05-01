function [result] = PearsonR(x, y)
%PearsonR Gives pearson correlation coefficient.

    ssX = SS(x);
    ssY = SS(y);
    result = SP(x, y) / sqrt(ssX * ssY);
end
