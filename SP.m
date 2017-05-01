function [result] = SP(x, y)
%SP Sum of products between two sets of data (must be of same size)

    % Check and fix alignment
    [nX, dimX] = max(size(x));
    [nY, dimY] = max(size(y));
    assert(nX == nY);
    if dimY ~= dimX
        x = x';
    end
    
    % Compute
    mX = mean(x);
    mY = mean(y);
    result = sum((x - mX) .* (y - mY));
    assert(max(size(result)) == 1);
end

