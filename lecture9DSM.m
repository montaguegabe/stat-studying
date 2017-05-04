% We start with any kind of distribution that we want
distr = sin((1:64) / 10) * 5 + 10; % start with a wacky distribution
population = DistrToData(distr);
histogram(population);

%%

% Let's prove the central limit theorem for this particular population
numSamples = 1000;
sampleSize = 40; % rule of thumb says it must be at least 30

% Take a bunch of samples (without replacement or with - doesn't matter?)
samples = zeros(numSamples, sampleSize);
for i = 1:numSamples
    samples(i, :) = datasample(population, sampleSize);
end

means = Mean(samples, 2);
histogram(means);

%%
% We find that the distribution is normal, even though the original
% distribution was not normal.

%%

% Further analysis of DSM stats vs population stats
meanPop = Mean(population);
meanDsm = Mean(means);

stdPop = Std(population);
stdDsm = InferredStd(means);

clc();
fprintf("Pop mean: %.2f\n", meanPop);
fprintf("DSM mean: %.2f\n", meanDsm);
fprintf("\n");
fprintf("Pop std:           %.2f\n", stdPop);
fprintf("DSM std:           %.2f\n", stdDsm);
fprintf("DSM std * sqrt(n): %.2f\n", stdDsm * sqrt(sampleSize));

%%
% We see that the standard deviation of the DSM is $\frac{\sigma}{\sqrt{n}}$


