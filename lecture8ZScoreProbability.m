% Generate a binomial distribution - number of heads

p = 0.5;
trials = 1000;
flipsPerTrial = 50;

flips = round(rand(trials, flipsPerTrial));
numHeads = sum(flips, 2);

histogram(numHeads);

%%
% We find the the distribution of number of heads is normal with mean $np$
% and variance $np(1-p)$
%
% Using this fact, let's estimate the proportion of times that the number of
% heads was between 28 and 31.

clc();
fprintf("Sample mean number of heads:            %.2f\n", Mean(numHeads));
fprintf("Normal estimation mean number of heads: %.2f\n", flipsPerTrial * p);
fprintf("\n");

% QUESTION: Which type of variance to use below?
fprintf("Sample variance of number of heads:                %.2f\n", InferredVar(numHeads));
fprintf("Normal estimation for variance of number of heads: %.2f\n", flipsPerTrial * p * (1 - p));
fprintf("\n");

meanApprox = flipsPerTrial * p;
varApprox = flipsPerTrial * p * (1 - p);
stdApprox = sqrt(varApprox);

upper = 31;
lower = 28;

% To think about: Why are we adding and subtracting 0.5?
upperZ = Z(upper + 0.5, meanApprox, stdApprox);
lowerZ = Z(lower - 0.5, meanApprox, stdApprox);

proportionEstimate = normcdf(upperZ) - normcdf(lowerZ);
proportion = max(size(numHeads(numHeads >= 28  & numHeads <= 31))) / trials;

fprintf("Actual proportion of heads b/w %i and %i:                %.2f \n", lower, upper, proportion);
fprintf("Normal estimation for proportion of heads b/w %i and %i: %.2f \n", lower, upper,  proportionEstimate);
fprintf("\n");

% Now lets get the 30th percentile for number of heads
heads30th = prctile(numHeads, 30); % Note: don't use this function for continuous variables!
heads30thEstimate = ZInv(norminv(0.30, 0, 1), meanApprox, stdApprox);
% We could also write:
% heads30thEstimate = norminv(0.30, meanApprox, stdApprox);

fprintf("Actual 30th percentile:                %.2f \n", heads30th);
fprintf("Normal estimation for 30th percentile: %.2f \n", heads30thEstimate);

% To do: Drawing the curves



