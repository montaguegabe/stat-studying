% Lets simulate responses to a survey that asks how likely you are to help
% someone. In one survey the person you could help is victim of misfortune
% and in the other they are also the cause of their misfortune.

popSize = 15000;

% Simulate responses on a Likert scale from 1 to 5.
populationAnswerStd = 1.1;
helpCause = randn(popSize, 1) * populationAnswerStd + 2.3; % population 1
helpVictim = randn(popSize, 1) * populationAnswerStd + 2.6; % population 2

helpCauseMean = Mean(helpCause);
helpCauseStd = Std(helpCause); % should be populationAnswerStd
helpVictimMean = Mean(helpVictim);
helpVictimStd = Std(helpVictim); % should be populationAnswerStd

% We have two different sample sizes!
n1 = 80;
n2 = 20;

% If we draw two samples and compare the difference of their means, what
% will be the standard error?

trials = 5000;
sampleMeansDifference = zeros(trials, 1);
for i = 1:trials
    
    sample1 = datasample(helpCause, n1);
    sample2 = datasample(helpVictim, n2);
    sampleMeansDifference(i) = Mean(sample2) - Mean(sample1);
end

% Plot the distribution of sample differences
histogram(sampleMeansDifference);
standardError = InferredStd(sampleMeansDifference);

% Compare the standard error to the formula standard error
clc();
fprintf("\n");
fprintf("Calculated standard error:   %.2f\n", standardError);

% To think about: This isn't strictly the formula since we are using
% parameters directly. Why does this work?
addedStandardError = sqrt(helpCauseStd^2 / n1 + helpVictimStd^2 / n2);
fprintf("Standard error from formula: %.2f\n", addedStandardError);

%%
% We notice that the calculated standard error is what we would expect from
% adding the variances of the individual standard errors.

%%

% What if we couldn't use the population variance and instead had to
% estimate it from out two samples?

trials = 5000;
varianceEstimations = zeros(trials, 1);
for i = 1:trials
    
    sample1 = datasample(helpCause, n1);
    sample2 = datasample(helpVictim, n2);
    
    % Calculate a variance estimation given the two samples, giving weight
    % to the larger of the two samples
    varianceEstimations(i) = InferredVarPooled(n1, SS(sample1), n2, SS(sample2));
end

% Compare the observed expected estimation of variance with the actual
% variance
varianceEstimationAvg = mean(varianceEstimations);

fprintf("\n");
fprintf("Average estimation of variance given two samples:   %.2f\n", ...
    varianceEstimationAvg);
fprintf("Actual variance:                                    %.2f\n", ...
    populationAnswerStd ^ 2);

%%
% We find that on average, we can estimate the variance of the two
% populations just given two samples of sizes n1 and n2.

%%

% Now we can use this to investigate if the means of the two surveys are 
% different
alpha = 0.01;
% Use same n1 and n2 as before

% We predict a negative cause help mean - victim help mean: victim help
% should be bigger
altSign = -1;

power = TestTIndependentSamplesPower(alpha, n1, n2, 0, ...
    altSign, helpCauseMean, helpCauseStd, helpVictimMean, helpVictimStd);

fprintf("\n");
fprintf("We expect the test to reject the null %i%% of the time.\n", ...
    round(power * 100));

trials = 15000;
correctPositives = 0;
for i = 1:trials
    
    sample1 = datasample(helpCause, n1);
    sample2 = datasample(helpVictim, n2);
    
    rejectsNull = TestTIndependentSamples(sample1, sample2, alpha, altSign);
    
    if rejectsNull == true
        correctPositives = correctPositives + 1;
    end
end

fprintf("The proportion of times the test succeeded was %i/%i = %.2f\n", ...
    correctPositives, trials, correctPositives / trials);

%%
% We observe the power correctly predicts the test behavior

%%

% Let's do a confidence interval for the difference of population means for
% a single sample

sample1 = datasample(helpCause, n1);
sample2 = datasample(helpVictim, n2);
confidence = 0.95;
[lower, upper] = TestTIndepSamplesInterval(sample1, sample2, confidence);

actualDifference = helpCauseMean - helpVictimMean;

fprintf("\n");
fprintf("%i%% confidence interval is (%.2f,%.2f)\n", confidence * 100, ...
    lower, upper);
if lower <= actualDifference && upper >= actualDifference
    fprintf("Correct: The mean is in this interval.\n");
else
    fprintf("Incorrect! The mean is NOT in this interval!\n");
end
