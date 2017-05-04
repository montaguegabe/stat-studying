% If we have more than 2 samples, what is the variance due to chance?

popSize = 100000;
levels = 5;
population = vec2mat(randn(popSize * levels, 1) * 0.5 + 3.14, levels); % using random numbers 0.5, 3.14

%%

% What is the variance just due to chance of three samples?
n = 10:5:35;
trials = 5000;
varianceBwMeans = zeros(trials, numel(n)); % the column will correspond to value of n
for i = 1:trials
    
    samples = zeros(max(n), levels);
    for level = 1:levels
        samples(:, level) = datasample(population(:, level), max(n));
    end
    
    % Now record the inferred variance among sample means
    for j = 1:numel(n)
        nValue = n(j);
        sampleMeans = Mean(samples(1:nValue, :), 1);
        varianceBwMeans(i, j) = InferredVar(sampleMeans);
    end
end

clc();
fprintf("\n");
meanVarianceBwMeans = Mean(varianceBwMeans, 1);
fprintf("Average variance of sample means n=%i: %.4f\n", max(n), ...
    meanVarianceBwMeans(numel(n)));

% Lets use math to predict as well...
populationNoFactors = reshape(population, [popSize * levels, 1]);
populationNoFactorsVar = Var(populationNoFactors)
fprintf("Average variance of sample means n=%i: %.4f\n", max(n), ...
    populationNoFactorsVar / max(n));

% Plot n vs the expected variance of sample means (calculated)
figure();
plot(n - min(n) + 1, meanVarianceBwMeans);
hold on;

% Plot n vs the expected variance of sample means (formula)
plot(n - min(n) + 1, populationNoFactorsVar ./ n);

%%
% We notice that the variance of sample means is the variance of the
% population divided by n.

% TODO: More on the connection between F numerator and variance

%% 

% Lets see what the F distribution looks like

n = 30;

trials = 5000;
fs = zeros(trials, 1);
for i = 1:trials
    
    % Obtain samples
    samples = zeros(n, levels);
    for level = 1:levels
        samples(:, level) = datasample(population(:, level), n);
    end
    
    [~, f, ~] = TestAnova(samples, repmat(n, [levels, 1]), 0.05);
    
    fs(i) = f;
end

figure();
histogram(fs);

%%
% We observe the proper distribution shape of an F distribution.

%%

% What would the distribution for an alternative hypothesis (nonzero
% variance across means) look like?

% Modify so that there is actually a difference in means between levels
population(:, 1) = population(:, 1) + 1;

% Copied from above

trials = 5000;
fs = zeros(trials, 1);
for i = 1:trials
    
    % Obtain samples
    samples = zeros(n, levels);
    for level = 1:levels
        samples(:, level) = datasample(population(:, level), n);
    end
    
    sampleMeans = Mean(samples, 1);
    samplesCombined = reshape(samples, [n * levels, 1]);
    
    % Get the variances within
    samplesCombinedVar = InferredVar(samplesCombined);
    meansVar = InferredVar(sampleMeans); % double check
    
    f = meansVar / samplesCombinedVar;
    
    fs(i) = f;
end

figure();
histogram(fs);
axis([0 1.5 0 600])

% End copied from above

%%
% We haven't learned anything about that distribution - its peak is not at
% one. It looks normal, but is bounded below by 0. Therefore it is hard to
% reason about, which we need to do in order to compute ANOVA power.

%%

% Let's set up a situation where we have 3 samples to compare, as in
% lecture, where LTH = Likely to help someone on a Likert scale 1-5

% Suppose there is an effect
popSize = 300000;
lthStd = 0.7;
levels = 3;
lthAlone = randn(popSize, 1) * lthStd + 1.9;
lthOne = randn(popSize, 1) * lthStd + 2.2; % one bystander
lthTwo = randn(popSize, 1) * lthStd + 2.6; % two bystanders

combinedLth = [lthAlone, lthOne, lthTwo];
flatLth = reshape(combinedLth, [levels * popSize, 1]);

% Compute population statistics on how much variance between groups we have
% created:
popVarBetween = Var(Mean(samples, 1));
popVarWithin = sum(Var(samples, 1));

fprintf("\n");
fprintf("Population variance between groups: %.2f\n", popVarBetween);
fprintf("Population variance within groups:  %.2f\n", popVarWithin);

% We will test if there is variance between the population level means
alpha = 0.05;
n = 30;

% Obtain samples
samples = zeros(n, levels);
for level = 1:levels
    samples(:, level) = datasample(combinedLth(:, level), n);
end

% Run test
[rejectNull, f, p, msBetween, msWithin] = TestAnova(samples, repmat(n, [levels, 1]), alpha);

fprintf("\n");
fprintf("f = %.2f, p = %.2f, msBetween = %.2f, msWithin = %.2f\n", ...
    f, p, msBetween, msWithin);
if rejectNull
    fprintf("Rejected null hypothesis\n");
else
    fprintf("Failed to rejected null hypothesis (Type 2 error)!\n");
end